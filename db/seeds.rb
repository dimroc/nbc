Dir.glob('db/seeds/**/*.rb') { |filename| require Rails.root.join filename[0..-4] }
