ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.resources :content_filters
  end

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
  
  # groups mapping for a convenient url
  map.group '/groups/:id', :controller => 'collectives', :action => 'show'
  
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

  map.resources :videos
  map.resources :events, :collection => { :list_promoted => :get }
  map.resources :articles
  map.resources :action_alerts
  map.resources :collectives
  
  map.resource :admin do |admin|
    admin.resources :snippets, :name_prefix => 'admin_', :controller => 'admin/snippets'
  end
  
  map.admin_main 'admin/main', :controller => 'admin/main'
  map.latest_comments 'admin/main/latest_comments', :controller => 'admin/main', :action => 'latest_comments'
  map.admin_action_alerts 'admin/action_alerts', :controller => 'admin/action_alerts'
  map.categories 'admin/categories/', :controller => 'admin/category'
  map.pages 'admin/pages', :controller => 'admin/page'
  map.users 'admin/users', :controller => 'active_rbac/user'
  map.roles 'admin/roles', :controller => 'active_rbac/role'
  map.static_permissions 'admin/static_permissions', :controller => 'active_rbac/static_permission'
  map.account 'account', :controller => 'active_rbac/login', :action => 'index'
  map.login 'login', :controller => 'active_rbac/login', :action => 'login'
  map.logout 'logout', :controller => 'active_rbac/login', :action => 'logout'
  map.register 'register', :controller => 'active_rbac/registration'
  map.publish 'publish', :controller => 'page', :action => 'show', :title => 'Publish Page'
  map.edit_collective_memberships 'collectives/:id/edit_memberships', :controller => 'collectives', :action => 'edit_memberships'
  map.add_collective_membership 'collectives/:id/add_membership', :controller => 'collectives', :action => 'add_membership'
  map.destroy_collective_membership 'collectives/destroy_membership/:id', :controller => 'collectives', :action => 'destroy_membership'

  # map the login and registration controller somewhere prettier than "active_rbac/foo"
  map.connect '/login', :controller => 'active_rbac/login', :action => 'login'
  map.connect '/logout', :controller => 'active_rbac/login', :action => 'logout'
  map.connect '/register/confirm/:user/:token', :controller => 'active_rbac/registration', :action => 'confirm'
  map.connect '/register/:action/:id', :controller => 'active_rbac/registration'
  
  # hide '/active_rbac/*'
  map.connect '/active_rbac/*', :controller => 'home', :action => 'index'
      
  map.connect '/page/:title', :controller => 'page', :action => 'show', :title => 'default'
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
  map.upcoming_events_by_tag_feed 'feeds/upcoming_events_by_tag', :controller => 'feeds', :action => 'upcoming_events_by_tag'  
  map.upcoming_events_by_place_feed 'feeds/upcoming_events_by_place', :controller => 'feeds', :action => 'upcoming_events_by_place' 
  
  # base url of application
  map.root :controller => 'home', :action => 'index'

  map.connect '/admin/', :controller => "admin/category"
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
