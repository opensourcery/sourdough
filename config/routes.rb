ActionController::Routing::Routes.draw do |map|
  map.from_plugin :sourdough
  map.comatose_admin
  map.comatose_root 'pages'
end
