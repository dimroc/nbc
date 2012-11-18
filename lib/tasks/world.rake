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
      puts "Creating NYC..."
      World.find_by_slug("nyc").try(:destroy)

      Loader::World.generate({
        name: "NYC",
        region_name_key: "BoroCD",
        block_length: 250
      }).save!
    end

    desc "Generate blocks that represent Manhattan"
    task :manhattan => :environment do
      puts "Creating Manhattan..."
      World.find_by_slug("manhattan").try(:destroy)

      Loader::World.generate({
        name: "Manhattan",
        region_name_key: "BoroCD",
        block_length: 700,
        tolerance: 0.5
      }).save!
    end

    desc "Generate blocks that represent USA (Contiguous states)"
    task :usa => :environment do
      puts "Creating USA (contiguous states)..."
      World.find_by_slug("usa").try(:destroy)

      Loader::World.generate({
        name: "USA",
        region_name_key: "NAME",
        block_length: 250_000,
        tolerance: 500
      }).save!
    end
  end
end
