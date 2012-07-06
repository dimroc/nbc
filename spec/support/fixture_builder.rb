FixtureBuilder.configure do |fbuilder|
  fbuilder.files_to_check += Dir["spec/factories/**/*.rb", "spec/support/fixture_builder.rb"]

  fbuilder.factory do
    # Users
    fbuilder.name(:standard_user, FactoryGirl.create(:user))

    # Regions
    fbuilder.name(:nyc, FactoryGirl.create(:region, name: "New York City"))
    fbuilder.name(:middle_earth, FactoryGirl.create(:region, name: "Middle Earth", width: 5, height: 5))
  end
end
