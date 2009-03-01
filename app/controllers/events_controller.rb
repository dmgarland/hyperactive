class EventsController < ContentController

  def index
    @cloud = Tag.cloud(:limit => 20)
    
    if params[:moderation_status].blank?
      @content = Event.visible.upcoming.paginate(:order => 'date ASC', :page => page_param)
    else
      @content = model_class.paginate(
        :conditions => ['moderation_status = ? and date >=?', params[:moderation_status], Date.today.to_s], 
        :order => 'date ASC', 
        :page => page_param)
    end
  end
  
  def list_by_event_group
    event_group_id = params[:id]
    @content = Event.find_all_by_event_group_id(event_group_id, :conditions => ['moderation_status != ?', "hidden"])   
  end
  
  def list_by_month
    if params[:date] == nil
      start_date = Date.today
      year = start_date.year
      month = start_date.month
    else
      year = params[:date].split("-")[0].to_i
      month = params[:date].split("-")[1].to_i
    end
    @date = Date.new(year,month,1)
    datestring = @date.to_s
    # HACK: make sure the year rolls over if we're in December so this next bit doesn't explode.
    if @date.month < 12
      datestring2 = (Date.new(@date.year,@date.month+1)).to_s
    else
      datestring2 = (Date.new(@date.year+1, 1)).to_s
    end
    @content = Event.find(:all,
      :conditions => ['moderation_status != ? and date > ? and date < ?', "hidden", datestring, datestring2], 
      :order => 'date ASC')
  end
  
  def calendar_month
    list_by_month
    @month_display = MonthDisplay.new(@date)
    render :layout => 'one_column'
  end
  
  def list_by_day
    if params[:date] == nil
      @date = Date.today
    else
      @date = splitdate(params[:date])
    end  
    datestring = @date.to_s
    page = (params[:page] ||= 1).to_i
    @content = Event.paginate(
      :conditions => ['moderation_status != ? and date = ?', "hidden", datestring], 
      :page => page)  
  end
  
  def list_by_week
    if params[:date] == nil
      today = Date.today
      @date = Week.new(today).first_day_in_week
    else
      date = splitdate(params[:date])
      @date = Week.new(date).first_day_in_week
      # TODO: refactor everything that currently uses my Month and Week
      # code in /lib once I figure out how this works:
      #@date = Time.new(year,month,day).beginning_of_week 
      # There are apparently a whole pile of date code additions to rails that
      # I'm not using.     
    end  
    list_one_week(@date)
  end
  
  def list_seven_days
    if params[:date] == nil
      @date = Date.today
    else
      @date = splitdate(params[:date])
    end  
    list_one_week(@date)
  end
  
  def list_one_week(date)
    @date = date
    datestring = @date.to_s
    datestring2 = (@date + 7).to_s
    @content = Event.paginate(
      :conditions => ['moderation_status != ? and date > ? and date < ?', "hidden", datestring, datestring2], 
      :page => page_param)   
  end
  
  def ical_download
    @content  = Event.find(params[:id])
    cal = Vpim::Icalendar.create2
    cal.add_event do |e|
      e.dtstart       @content.date
      e.dtend         @content.date
      e.summary       @content.title
      e.description   @content.summary + "\n\n" + @content.body
    end

    icsfile = cal.encode
    send_data(icsfile, :type => "text/calendar", :filename => "#{@content.title.downcase.gsub(/ /, "_")}.ics")
  end
  
  protected
  
  # We're inheriting almost all of the functionality from the ContentController
  # superclass.  This tells ContentController which model class we're dealing with.
  #
  def model_class 
    Event
  end
    
  # sets the event end date to nil if no end date has been submitted from the form.
  def check_end_date
    if params[:event_has_end_date] == nil
      @content.end_date = nil
    end
  end
  
  # checks whether a submitted event is a repeating event.
  def check_event_group
    event_repeat_type = params[:event_repeat_type]
    case event_repeat_type
      when "none"
      when "repeat_simple"
        setup_simple_repeat_events
      when "repeat_complex"
        setup_complex_repeat_events
    end
  end
  
  # sets up simple repeated events, like "repeat every second day" or "repeat every second week"
  def setup_simple_repeat_events
    @content.reload
    @event_group = create_event_group(@content)
    event_repeats_every = params[:event_repeats_every].to_i # an integer
    period = params[:event_repeats_dwm] # day, week, or month
    @start_date = DateTime.new(@content.date.year, @content.date.month, @content.date.day, @content.date.hour, @content.date.min)
    @next_date = @start_date
    @until_date = DateTime.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    while (@next_date < @until_date && @next_date < @start_date >> 6)     
      if (period == "day")
        @next_date = @next_date + event_repeats_every
        if (@next_date < @until_date)
          setup_event_copy(@next_date)
        end
      elsif (period == "week")
        @next_date = @next_date + (7 * event_repeats_every)
        if(@next_date < @until_date)
          setup_event_copy(@next_date)
        end
      elsif (period == "month")
        @next_date = @next_date >> event_repeats_every
        if(@next_date < @until_date)
          setup_event_copy(@next_date)
        end
      end 
    end
  end
    
  # sets up complex repeat events, like "repeat on the last Tuesday of every second month."  
  def setup_complex_repeat_events
    @content.reload
    @event_group = create_event_group(@content)
    @start_date = DateTime.new(@content.date.year, @content.date.month, @content.date.day, @content.date.hour, @content.date.min)
    @until_date = DateTime.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    event_repeats_which_week = params[:event_repeats_which_week]
    event_repeats_week_day = params[:event_repeats_week_day]
    event_repeat_period = params[:event_repeat_period]
    month = Month.new(@start_date)
    @next_date = find_correct_day_for_complex_event(month, event_repeats_week_day, event_repeats_which_week)
    if(@start_date >= @next_date)
      month = Month.new(month.first_day_in_month >> (1 * event_repeat_period.to_i))
      @next_date = find_correct_day_for_complex_event(month, event_repeats_week_day, event_repeats_which_week)
    end
    while (@next_date < @until_date && @next_date < @start_date >> 6)
      setup_event_copy(@next_date)
      month = Month.new(month.first_day_in_month >> (1 * event_repeat_period.to_i))
      @next_date  = find_correct_day_for_complex_event(month, event_repeats_week_day, event_repeats_which_week)
    end
  end
  
  # finds the correct day for a complex repeated event, given a month, a weekday,
  # and a repeat period.
  def find_correct_day_for_complex_event(month, event_repeats_week_day, event_repeats_which_week)
    if(event_repeats_which_week == "last")
      @temp_day = month.last_in_month(event_repeats_week_day)
    else
      first_named_weekday_in_month = month.first_in_month(event_repeats_week_day)
      @temp_day = first_named_weekday_in_month + (7 * (assign_week_number(event_repeats_which_week) - 1))
    end
    @temp_day = DateTime.new(@temp_day.year, @temp_day.month, @temp_day.day, @content.date.hour, @content.date.min)
  end
  
  # assigns a week integer to a week-of-the-month string.
  def assign_week_number(week)
    case week
      when "first"
        return 1
      when "second"
        return 2
      when "third"
        return 3
      when "fourth"
        return 4
    end   
  end
  
  # copies an event and applies a new date to it.
  def setup_event_copy(next_date)
    @event2 = Event.copy(@content)
    @event2.event_group = @event_group
    @event2.date = next_date
    @event2.save
    @event2.tag_with(@content.tag_list)
    @event2.place_tag_with(@content.place_tag_list)
  end
  
  # creates an event group for an event.
  def create_event_group(event)
      event_group = EventGroup.new
      event_group.save
      event.event_group = event_group
      event.save
      event_group
  end
    
  def splitdate(datestring)
    year = datestring.split("-")[0].to_i
    month = datestring.split("-")[1].to_i
    day = datestring.split("-")[2].to_i  
    date = Date.new(year, month, day)
    date
  end
  
end
