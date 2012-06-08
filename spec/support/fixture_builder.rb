FixtureBuilder.configure do |fbuilder|
  fbuilder.files_to_check += Dir["spec/factories/**/*.rb", "spec/support/fixture_builder.rb"]

  fbuilder.factory do
    fbuilder.name(:standard_user, FactoryGirl.create(:user))
  end
end
