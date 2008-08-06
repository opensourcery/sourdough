# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.
resource :session, :member => { :forgotten_password => :get, :reset_password => :put, :resend_activation => :put}
#  resource :admin, :member => { :users => :get }
resources :users do |users|
  users.resource :photos
end


resource :admin, :controller => 'admin/home' do |admin|
  admin.resources :users, :member => { :make_admin => :post, :revoke_admin => :post, :remove_ban => :post, :ban => :post, :admin_activate => :post, :admin_reset_password => :post }, :controller => 'admin/users', :name_prefix => 'admin_' do |users|
    users.resource :photos, :controller => 'admin/photos', :name_prefix => 'admin_'
  end
end

terms 'terms', :controller => 'home', :action => 'terms'
home '/', :controller => 'home'
activate "/users/activate/:activation_code", :controller => 'users', :action => 'activate'
signup '/signup', :controller => 'users', :action => 'new'
login  '/login', :controller => 'sessions', :action => 'new'
logout '/logout', :controller => 'sessions', :action => 'destroy'
connect ':controller/service.wsdl', :action => 'wsdl'
connect '', :controller => 'home'

# Install the default route as the lowest priority.
connect ':controller/:action/:id.:format'
connect ':controller/:action/:id'

