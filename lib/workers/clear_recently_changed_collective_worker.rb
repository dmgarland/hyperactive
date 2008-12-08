#class ClearRecentlyChangedCollective < BackgrounDRb::MetaWorker
class ClearRecentlyChangedCollectiveWorker < BackgrounDRb::Rails
 
  repeat_every 1.days
  first_run Time.now
    
  def do_work(args)
    sql = 'update collectives set moderation_status = NULL where moderation_status = "recently_changed"'
    ActiveRecord::Base.connection.update(sql)
  end

end 
