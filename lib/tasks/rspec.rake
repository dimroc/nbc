begin
  require 'rspec/core/rake_task'

  namespace :spec do
    desc "Run examples that generate fixtures for use in Jasmine"
    RSpec::Core::RakeTask.new(:generate_jasmine_fixtures) do |task|
      task.pattern = "./spec/{controllers,views}/**/*_spec.rb"
      task.rspec_opts = "-t jasmine_fixture"
    end
  end
end
