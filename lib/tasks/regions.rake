namespace :regions do
  namespace :generate do
    desc "Generate a region of blocks"
    task :empty, [:name, :width, :height] => :environment do |t, args|
      args.with_defaults(width: 20, height: 20)
      puts "Generating blocks with arguments: #{args.inspect}"

      region = FactoryGirl.build(:region, name: args.name, width: args.width.to_i, height: args.height.to_i)
      if region.save
        puts "Created region #{region.name}"
      else
        puts "Errors: #{region.errors}"
      end
    end

    desc "Generate blocks that represent New York City"
    task :nyc => :environment do
      puts "Creating new york city..."
      shapefile = "lib/assets/shapefiles/nyc/regions"
      Region.from_shapefile("New York City", shapefile, 400).save!
    end

    desc "Delete any nyc entry and regenerate"
    task :recreate_nyc => :environment do
      Region.find_by_slug("new-york-city").try(:destroy)
      Rake::Task["regions:generate:nyc"].invoke
    end
  end
end
