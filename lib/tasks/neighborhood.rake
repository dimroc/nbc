namespace :neighborhood do
  desc "Generate json files for all neighborhoods"
  task :write => :environment do
    Loader::Neighborhood.write_json
  end

  desc "Generate json files of each neighborhood's building perimeters"
  task :write_buildings => :environment do
    Loader::Neighborhood.write_building_perimeters_json
  end
end