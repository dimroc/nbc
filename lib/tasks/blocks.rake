namespace :blocks do
  desc "Generate blocks of a particular width for a particular region"
  task :generate, [:block_width, :width, :height] => :environment do |t, args|
    args.with_defaults(block_width: 5, width: 100, height: 100)
    puts "Generating blocks with arguments: #{args.inspect}"
    BlockGenerator.generate(args.region, args.block_width, args.width, args.height)
  end

  desc "Generate blocks that represent New York City"
  namespace :generate do
    task :newyorkcity => :environment do
      puts "creating new york city"
    end
  end
end
