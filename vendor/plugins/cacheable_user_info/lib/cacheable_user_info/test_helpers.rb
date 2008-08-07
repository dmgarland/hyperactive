module CacheableUserInfo
  module TestHelpers
    def flash_cookie
      return {} unless cookies['user_info']
      JSON.parse(cookies['user_info'].first)
    end    
  end
end