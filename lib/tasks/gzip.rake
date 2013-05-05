namespace :gzip do
  desc "Gzip all pregenerated json in public/static"
  task :static do
    Gzipper.static_json
  end
end
