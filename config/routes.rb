ActionController::Routing::Routes.draw do |map|
  map.resource :session, :member => { :forgotten_password => :get,
                                      :reset_password => :put}
#  map.resource :admin, :member => { :users => :get }
  map.resources :users do |users|
    users.resource :photos
  end

  map.resource :admin, :controller => 'admin/home' do |admin|
    admin.resources :users, :controller => 'admin/users', :name_prefix => 'admin_' do |users|
      users.resource :photos, :controller => 'admin/photos', :name_prefix => 'admin_'
    end
  end

  map.terms 'terms', :controller => 'home', :action => 'terms'
  map.edit_profile  '/users/:login;edit', :controller => 'users', :action => 'edit'
  map.home '/', :controller => 'home'
  map.activate "/users/activate/:activation_code", :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'session', :action => 'new'
  map.logout '/logout', :controller => 'session', :action => 'destroy'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect '', :controller => 'home'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
