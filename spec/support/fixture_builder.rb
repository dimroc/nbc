FixtureBuilder.configure do |fbuilder|
  fbuilder.files_to_check += Dir["spec/factories/**/*.rb", "spec/support/fixture_builder.rb"]

  fbuilder.factory do
    # Users
    fbuilder.name(:standard_user, FactoryGirl.create(:user))

    # Worlds
    @nyc =
      World.build_from_shapefile(
        "lib/assets/shapefiles/nyc/region",
        "BoroName" => "name")
    @nyc.name = "NYC"
    @nyc.save!

    @miami =
      World.build_from_shapefile("spec/fixtures/holed_square/holed_square")
    @miami.name = "Miami"
    @miami.save!
  end
end
