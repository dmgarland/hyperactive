# Periodically checks to see whether new content needs to be checked based
# on content filters.
#
class AutoModerationWorker < BackgrounDRb::Rails
  
  repeat_every 5.minutes
  
  def do_work(args)
    filters = ContentFilter.find(:all)
    fields_to_check = ["title", "body", "summary", "published_by"]
    content_to_check = Content.find(:all, :conditions => ["auto_moderation_checked = ?", false])
    content_to_check.each do |content|
      @found_something_to_hide = false
      @filter_message = ""
      fields_to_check.each do |field|
        filters.each do |filter|
          filter.content_filter_expressions.each do |filter_expression|
            if content.send(field) =~ /#{filter_expression.regexp}/i
              content.moderation_status = "hidden"
              @found_something_to_hide = true
              @filter_message = filter.summary
            end
          end
        end
      end
      ContentHideMailer.deliver_hide(content, @filter_message, "marcos") if found_something_to_hide     
      content.auto_moderation_checked = true
      content.save!
    end
  end
  
  def status
    return "running"
  end

end
