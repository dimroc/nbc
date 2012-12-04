namespace :world do
  desc "Generate all worlds or a specific world from worlds.yml"
  task :generate, [:name] => :environment do |t, args|
    name = args[:name]

    if name
      Loader::World.from_yml!("config/worlds.yml", name)
    else
      Loader::World.from_yml!("config/worlds.yml")
    end

    Dir.glob("public/static/**/*.json") do |filename|
      puts "Compressing #{filename} to gzip"

      gzip_filename = "#{filename}.gz"
      FileUtils.rm_r gzip_filename

      Zlib::GzipWriter.open(gzip_filename) do |gz|
        gz.mtime = File.mtime(filename)
        gz.orig_name = filename
        gz.write IO.binread(filename)
      end
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

  desc "Destroy all worlds or a specific world"
  task :destroy, [:name] => :environment do |t, args|
    name = args[:name]

    if name
      world = World.where("name ILIKE #{name}").first
      FileUtils.rm_rf ["public/static/#{world.slug}/"]
      world.destroy
    else
      World.destroy_all
      FileUtils.rm_rf ["public/static/"]
    end
  end
end
