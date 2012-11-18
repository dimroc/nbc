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
      World.find_by_slug("new-york-city").try(:destroy)
      shapefile = "lib/data/shapefiles/nyc/region"
      world = Loader::World.from_shapefile(shapefile, "BoroCD" => "name")
      world.regenerate_blocks(250)
      world.name = "New York City"
      world.save!
    end

    desc "Generate blocks that represent Manhattan"
    task :manhattan => :environment do
      puts "Creating Manhattan..."
      World.find_by_slug("manhattan").try(:destroy)
      shapefile = "lib/data/shapefiles/manhattan/region"
      world = Loader::World.from_shapefile(shapefile, "BoroCD" => "name")
      world.regenerate_blocks(700)
      world.name = "Manhattan"
      world.save!
    end

    desc "Generate blocks that represent USA (Contiguous states)"
    task :usa => :environment do
      puts "Creating USA (contiguous states)..."
      World.find_by_slug("usa").try(:destroy)
      shapefile = "lib/data/shapefiles/usa/region"
      world = Loader::World.from_shapefile(shapefile, "NAME" => "name")

      puts "Generating blocks and threejs model..."
      world.regenerate_blocks(140_000)
      world.name = "USA"
      world.save!
    end
  end
end
