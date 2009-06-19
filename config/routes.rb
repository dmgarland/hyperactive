ActionController::Routing::Routes.draw do |map|
  map.resources :other_medias

  map.admin '/admin', :controller => 'admin/main', :action => 'index' 
  map.namespace(:admin) do |admin|
    admin.resources :quotes
    admin.resources :settings
    admin.resources :settings
    admin.resources :settings
    admin.resources :settings
    admin.resources :settings
    admin.resources :content_filters, :pages  
    admin.resources :snippets
  end

  map.resources :pages

  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Here's a sample route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # map the role based access control stuff into '/admin/'
  map.connect '/admin/group/:action/:id',:controller => 'active_rbac/group'
  map.connect '/admin/role/:action/:id', :controller => 'active_rbac/role'
  map.connect '/admin/static_permission/:action/:id', :controller => 'active_rbac/static_permission'
  map.connect '/admin/user/:action/:id', :controller => 'active_rbac/user'

  # connect year and month to archive view
  map.archive_index '/archive/', :controller => 'archive', :action => 'index'
  map.archive_this_month '/archive/this_month', :controller => 'archive', :action => 'this_month'
  map.connect '/archive/this_month/:type', :controller => 'archive', :action => 'this_month'
  map.connect '/archive/:year', :controller => 'archive', :action => 'year_index'
  map.archive_default '/archive/:year/:month', :controller => 'archive', :action => 'month_index'
  map.connect '/archive/:year/:month/tag/:tag', :controller => 'archive', :action => 'tag_index'
  map.connect '/archive/:year/:month/place_tag/:place_tag', :controller => 'archive', :action => 'tag_index'
  map.connect '/archive/:year/:month/:type', :controller => 'archive', :action => 'month_index'

  map.archive_featured '/archive/:year/:month/featured', :controller => 'archive', :action => 'month_index'
  map.archive_promoted '/archive/:year/:month/promoted', :controller => 'archive', :action => 'month_index'
  map.archive_tag     '/archive/:year/:month/tag', :controller => 'archive', :action => 'tag_index'
  map.archive_place_tag '/archive/:year/:month/place_tag', :controller => 'archive', :action => 'place_tag_index'
  map.archive_this_month_featured '/archive/this_month/featured', :controller => 'archive', :action => 'this_month', :type => 'featured'
  map.archive_this_month_promoted '/archive/this_month/promoted', :controller => 'archive', :action => 'this_month', :type => 'promoted'
  
  # event mappings for listings
  map.list_by_month '/events/list_by_month', :controller => 'events', :action => 'list_by_month'
  map.list_by_week '/events/list_by_week', :controller => 'events', :action => 'list_by_week'
  map.list_by_day '/events/list_by_day', :controller => 'events', :action => 'list_by_day'  
  map.calendar_month '/events/calendar_month', :controller => 'events', :action => 'calendar_month'

  # content archive mappings
  map.archive_articles '/articles/archives/:page', :controller => 'articles', :action => 'archives'
  map.archive_events '/events/archives/:page', :controller => 'events', :action => 'archives'
  map.archive_videos '/videos/archives/:page', :controller => 'videos', :action => 'archives'

  # content listings by moderation status
  map.promoted_articles '/articles/list_promoted/:page', :controller => 'articles', :action => 'list_promoted'
  map.featured_articles '/articles/list_featured/:page', :controller => 'articles', :action => 'list_featured'
  map.promoted_events '/events/list_promoted/:page', :controller => 'events', :action => 'list_promoted'
  map.featured_events '/events/list_featured/:page', :controller => 'events', :action => 'list_featured'
  map.promoted_videos '/videos/list_promoted/:page', :controller => 'videos', :action => 'list_promoted'
  map.featured_videos '/videos/list_featured/:page', :controller => 'videos', :action => 'list_featured'
  map.promoted_other_medias '/other_medias/list_promoted/:page', :controller => 'other_medias', :action => 'list_promoted'  
  map.featured_other_medias '/other_medias/list_featured/:page', :controller => 'other_medias', :action => 'list_featured'

  # a better way to do the same thing
  map.resources :action_alerts, :articles, :pages, :videos
  map.resources :events, :collection => { :list_promoted => :get }
  map.resources :groups, :controller => :collectives, 
                         :collection => { :show_all => :get }, 
                         :has_many => :external_feeds
  
  map.streets 'actions', :controller => "action_alerts", :action => "list"
  map.admin_main 'admin/main', :controller => 'admin/main'
  map.latest_comments 'admin/main/latest_comments', :controller => 'admin/main', :action => 'latest_comments'
  map.admin_action_alerts 'admin/action_alerts', :controller => 'admin/action_alerts'
  map.categories 'admin/categories/', :controller => 'admin/category'
  map.users 'admin/users', :controller => 'active_rbac/user'
  map.roles 'admin/roles', :controller => 'active_rbac/role'
  map.static_permissions 'admin/static_permissions', :controller => 'active_rbac/static_permission'
  map.account 'account', :controller => 'active_rbac/my_account', :action => 'index'
  map.login 'login', :controller => 'active_rbac/login', :action => 'login'
  map.logout 'logout', :controller => 'active_rbac/login', :action => 'logout'
  map.register 'register', :controller => 'active_rbac/registration'
  map.publish 'publish', :controller => 'page', :action => 'show', :title => 'Publish Page'
  map.mission_statement 'mission-statement', :controller => 'page', :action => 'show', :title => 'Mission Statement'
  map.contact_us 'contact-us', :controller => 'page', :action => 'show', :title => 'Contact Us'
  map.get_involved 'get-involved', :controller => 'page', :action => 'show', :title => 'Get Involved'
  map.help 'help', :controller => 'page', :action => 'show', :title => 'Help'
  map.editorial_guidelines 'editorial-guidelines', :controller => 'page', :action => 'show', :title => 'Editorial Guidelines'
  map.edit_collective_memberships 'collectives/:id/edit_memberships', :controller => 'collectives', :action => 'edit_memberships'
  map.add_collective_membership 'collectives/:id/add_membership', :controller => 'collectives', :action => 'add_membership'
  map.destroy_collective_membership 'collectives/destroy_membership/:id', :controller => 'collectives', :action => 'destroy_membership'

  # map the login and registration controller somewhere prettier than "active_rbac/foo"
  map.connect '/login', :controller => 'active_rbac/login', :action => 'login'
  map.connect '/logout', :controller => 'active_rbac/login', :action => 'logout'
  map.connect '/register/confirm/:user/:token', :controller => 'active_rbac/registration', :action => 'confirm'
  map.connect '/register/:action/:id', :controller => 'active_rbac/registration'
  map.change_password '/change_password', :controller => 'active_rbac/my_account', :action => 'change_password'
  
  # hide '/active_rbac/*'
  map.connect '/active_rbac/*', :controller => 'home', :action => 'index'
      
  map.timeline '/timeline/timeline/', :controller => 'timeline', :action => 'timeline'
   
  # search mappings
  map.tag_item '/search/by_tag/:scope', :controller => 'search', :action => 'by_tag', :scope => 'internal_nyc'
  map.place_tag_item '/search/by_place_tag/:scope', :controller => 'search', :action => 'by_place_tag', :scope => 'internal_nyc'
  map.search '/search/find_content/', :controller => 'search', :action => 'find_content'
  map.featured_in_player '/featured_videos_json', :controller => 'videos', :action => 'featured_in_player'
  
  # feeds
  #
  map.feed_center 'feeds', :controller => 'feeds'           
  map.action_alert_feed '/feeds/action_alerts', :controller => 'feeds', :action => 'action_alerts'
  map.video_feed '/feeds/latest_videos', :controller => 'feeds', :action => 'latest_videos'
  map.latest_articles_feed 'feeds/latest_articles', :controller => 'feeds', :action => 'latest_articles'
  map.upcoming_events_feed 'feeds/upcoming_events', :controller => 'feeds', :action => 'upcoming_events'
  map.upcoming_events_by_tag_feed 'feeds/upcoming_events_by_tag/:scope', :controller => 'feeds', :action => 'upcoming_events_by_tag'  
  map.upcoming_events_by_place_feed 'feeds/upcoming_events_by_place/:scope', :controller => 'feeds', :action => 'upcoming_events_by_place' 
  map.articles_by_tag_feed 'feeds/articles_by_tag/:scope', :controller => 'feeds', :action => 'articles_by_tag' 
  

  # The job scheduler admin
  map.admin_job_scheduler '/admin/background_rb_status', :controller => 'admin/background_rb_status'
  

  # base url of application
  map.root :controller => 'home', :action => 'index'

  map.connect '/admin/', :controller => "admin/category"
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  
  # This should catch anything that's completely unrecognized and throw a 404 in production
  map.connect '*path' , :controller => 'error' , :action => 'index'
  
end
