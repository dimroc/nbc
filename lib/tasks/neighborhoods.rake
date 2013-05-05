namespace :neighborhood do
  desc "Generate json files of each neighborhood's building perimeters"
  task :write_buildings => :environment do
    Loader::Neighborhood.write_building_perimeters_to_file
  end
end
