class EventHiddenMailer < ActionMailer::Base

  def hide(event,reasons, user)
    @subject    = 'Event Hidden'
    @body      = {:event => event, :reasons => reasons, :user => user}
    @recipients = 'yossarian@aktivix.org'
    @from       = 'calendar@events.indymedia.org.uk'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def report(event,reasons, user)
    @subject    = 'Problem reported with content'
    @body      = {:event => event, :reasons => reasons, :user => user}
    @recipients = 'yossarian@aktivix.org'
    @from       = 'calendar@events.indymedia.org.uk'
    @sent_on    = Time.now
    @headers    = {}
  end  
  
  def unhide(event,reasons, user)
    @subject    = 'Event Unhidden'
    @body       = {:event => event, :reasons => reasons, :user => user}
    @recipients = 'yossarian@aktivix.org'
    @from       = 'calendar@events.indymedia.org.uk'
    @sent_on    = Time.now
    @headers    = {}
  end
end
