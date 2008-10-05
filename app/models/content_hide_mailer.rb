class ContentHideMailer < ActionMailer::Base

  def hide(content,reasons, user)
    setup_email
    @subject    = 'Content Hidden'
    @body      = {:content => content, :reasons => reasons, :user => user}
  end
  
  def report(content,reasons, user)
    setup_email    
    @subject    = 'Problem reported with content'
    @body      = {:content => content, :reasons => reasons, :user => user}
  end  
  
  def unhide(content,reasons, user)
    setup_email    
    @subject    = 'Content Unhidden'
    @body       = {:content => content, :reasons => reasons, :user => user}
  end
  
  def report_comment(comment, reasons, user)
    setup_email
    @subject    = 'Problem reported with comment'
    @body       = {:comment => comment, :reasons => reasons, :user => user}
  end
  
  def hide_comment(comment, reasons, user)
    setup_email
    @subject    = 'Comment hidden'
    @body       = {:comment => comment, :reasons => reasons, :user => user}
  end
  
  def unhide_comment(comment, reasons, user)
    setup_email
    @subject    = 'Comment unhidden'
    @body       = {:comment => comment, :reasons => reasons, :user => user}
  end  
  
  private 
  
  def setup_email
    @recipients = Hyperactive.moderation_email_recipients
    @from       = Hyperactive.moderation_email_from
    @sent_on    = Time.now
    @headers    = {}    
  end
end
