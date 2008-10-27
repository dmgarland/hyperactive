# Include hook code here
ActiveRecord.send :include, Slugger::SlugRedirect
ActiveRecord::Base.send :include, Slugger::ActiveRecordExtension
ActionController::Base.send :include, Slugger::ActionControllerExtension
