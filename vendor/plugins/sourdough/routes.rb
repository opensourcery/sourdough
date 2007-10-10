# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
resource :session, :member => { :forgotten_password => :get, :reset_password => :put}
#  resource :admin, :member => { :users => :get }
resources :users do |users|
  users.resource :photos
end


resource :admin, :controller => 'admin/home' do |admin|
  admin.resources :users, :member => { :remove_ban => :post, :ban => :post }, :controller => 'admin/users', :name_prefix => 'admin_' do |users|
    users.resource :photos, :controller => 'admin/photos', :name_prefix => 'admin_'
  end
end

terms 'terms', :controller => 'home', :action => 'terms'
edit_profile  '/users/:login;edit', :controller => 'users', :action => 'edit'
home '/', :controller => 'home'
activate "/users/activate/:activation_code", :controller => 'users', :action => 'activate'
signup '/signup', :controller => 'users', :action => 'new'
login  '/login', :controller => 'session', :action => 'new'
logout '/logout', :controller => 'session', :action => 'destroy'
connect ':controller/service.wsdl', :action => 'wsdl'
connect '', :controller => 'home'

# Install the default route as the lowest priority.
connect ':controller/:action/:id.:format'
connect ':controller/:action/:id'
