# Who gets emails when the site explodes?
#
unless RAILS_ENV == 'test'
  ExceptionNotifier.exception_recipients = %w(yossarian@aktivix.org)
  ExceptionNotifier.sender_address = %("Application Error" <error@london.indymedia.org.uk>)
  ExceptionNotifier.email_prefix = "[Hyperactive] "
end