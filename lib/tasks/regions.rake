namespace :regions do
  desc "Generate a region of blocks"
  task :generate, [:name, :width, :height] => :environment do |t, args|
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
  namespace :generate do
    task :newyorkcity => :environment do
      puts "creating new york city"
    end
  end
end
