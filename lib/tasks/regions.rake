namespace :regions do
  desc "Generate a region of blocks"
  task :generate, [:name, :width, :height] => :environment do |t, args|
    args.with_defaults(width: 30, height: 30)
    puts "Generating blocks with arguments: #{args.inspect}"
    region = RegionGenerator.generate(args.name, args.width, args.height)
    if region.valid?
      puts "Created region #{region.name}"
    else
      puts "Errors: #{region.errors}"
    end
  end

  desc "Generate blocks that represent New York City"
  namespace :generate do
    task :newyorkcity => :environment do
      puts "creating new york city"
    end
  end
end
