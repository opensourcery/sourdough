ActionController::Routing::Routes.draw do |map|

  map.resource :session
  map.resource :admin, :member => { :users => :get }
  map.resources :users do |users|
    users.resource :photos
  end
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'session', :action => 'new'
  map.logout '/logout', :controller => 'session', :action => 'destroy'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect '', :controller => 'home'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
