module CacheableUserInfo
  def self.included(base)
    base.after_filter :write_user_info_to_cookie
  end

  def write_user_info_to_cookie
    #cookie_user_info = cookies['user_info'] ? JSON.parse(cookies['user_info']) : {}
    cookies['user_info'] = current_user.login
  end
end
