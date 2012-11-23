namespace :world do
  desc "Generate all worlds or a specific world from worlds.yml"
  task :generate, [:name] => :environment do |t, args|
    name = args[:name]

    if name
      Loader::World.from_yml!("config/worlds.yml", name)
    else
      Loader::World.from_yml!("config/worlds.yml")
    end
  end

  namespace :generate do
    desc "Generate blocks that represent USA (Contiguous states)"
    task :usa => :environment do
      puts "Creating USA (contiguous states)..."
      World.find_by_slug("usa").try(:destroy)

      Loader::World.generate({
        name: "USA",
        region_name_key: "NAME",
        inverse_scale: 250_000,
        tolerance: 500
      }).save!
    end
  end
end
