# This file is part of Sourdough.  Copyright 2006,2007 OpenSourcery, LLC.  This program is free software, licensed under the terms of the GNU General Public License.  Please see the COPYING file in this distribution for more information, or see http://www.gnu.org/copyleft/gpl.html.

ActionController::Routing::Routes.draw do |map|
  map.resources :users do |users|
    users.resource :photos
  end
  
  map.resource :session, :member => { :forgotten_password => :get, :reset_password => :put, :resend_activation => :get}
  
  map.resource :admin, :controller => 'admin/home' do |admin|
    admin.resources :users, :member => { :make_admin => :post, :revoke_admin => :post, :remove_ban => :post, :ban => :post, :admin_activate => :post, :admin_reset_password => :post }, :controller => 'admin/users', :name_prefix => 'admin_' do |users|
      users.resource :photos, :controller => 'admin/photos', :name_prefix => 'admin_'
    end
  end
  
  map.edit_profile '/users/:id/edit', :controller => 'users', :action => 'edit'
  map.terms 'terms', :controller => 'home', :action => 'terms'
  map.home '/', :controller => 'home'
  map.activate "/users/activate/:activation_code", :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect '', :controller => 'home'
end
  
