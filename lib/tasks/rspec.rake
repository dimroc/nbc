begin
  require 'rspec/core/rake_task'

  namespace :spec do
    desc "Run examples that generate fixtures for use in Jasmine"
    RSpec::Core::RakeTask.new(:generate_jasmine_fixtures) do |task|
      task.pattern = "./spec/{controllers,views}/**/*_spec.rb"
      task.rspec_opts = "-t jasmine_fixture"
    end

    desc "Load spec fixtures into current environment"
    task "db:fixtures:load" do |task|
      puts "Loading spec fixtures..."
      ENV['FIXTURES_PATH'] = "spec/fixtures/"
      Rake::Task["db:fixtures:load"].invoke
    end
  end
end
