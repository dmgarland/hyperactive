class ContentHideMailer < ActionMailer::Base

  def hide(content,reasons, user)
    @subject    = 'Content Hidden'
    @body      = {:content => content, :reasons => reasons, :user => user}
    @recipients = 'yossarian@aktivix.org'
    @from       = 'calendar@events.indymedia.org.uk'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def report(content,reasons, user)
    @subject    = 'Problem reported with content'
    @body      = {:content => content, :reasons => reasons, :user => user}
    @recipients = 'yossarian@aktivix.org'
    @from       = 'calendar@events.indymedia.org.uk'
    @sent_on    = Time.now
    @headers    = {}
  end  
  
  def unhide(content,reasons, user)
    @subject    = 'Content Unhidden'
    @body       = {:content => content, :reasons => reasons, :user => user}
    @recipients = 'yossarian@aktivix.org'
    @from       = 'calendar@events.indymedia.org.uk'
    @sent_on    = Time.now
    @headers    = {}
  end
end
