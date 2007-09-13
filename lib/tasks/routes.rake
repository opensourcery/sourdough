desc "Print out all the currently defined routes."
task :routes => :environment do
  puts ActionController::Routing::Routes.routes.map {  |r|
    sprintf "%30s => %s", r.path.inspect, r.known.inspect
  } rescue puts ActionController::Routing::Routes.routes
end
