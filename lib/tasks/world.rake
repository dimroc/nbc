namespace :world do
  namespace :generate do
    desc "Generate a world with a region of blocks"
    task :empty, [:name, :width, :height] => :environment do |t, args|
      args.with_defaults(name: Faker::AddressUS.state, width: 20, height: 20)
      puts "Generating blocks with arguments: #{args.inspect}"

      world = FactoryGirl.build(:world, name: args.name)
      region = FactoryGirl.build(:region_with_geometry, 
                                 name: "#{world.name} region",
                                 width: args.width.to_i, 
                                 height: args.height.to_i)
      world.regions << region
      if world.save
        puts "Created world #{world.name}"
      else
        puts "Errors: #{world.errors.inspect}"
      end
    end

    desc "Generate blocks that represent New York City"
    task :nyc => :environment do
      puts "Creating new york city..."
      shapefile = "lib/assets/shapefiles/nyc/regions"
      world = World.build_from_shapefile(shapefile, "BoroName" => "name")
      world.name = "New York City"
      world.generate_blocks(10000)
      world.save!
    end

    desc "Delete any nyc entry and regenerate"
    task :recreate_nyc => :environment do
      World.find_by_slug("new-york-city").try(:destroy)
      Rake::Task["world:generate:nyc"].invoke
    end
  end
end
