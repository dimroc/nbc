FixtureBuilder.configure do |fbuilder|
  fbuilder.files_to_check += Dir["spec/factories/**/*.rb", "spec/support/fixture_builder.rb"]

  fbuilder.factory do
    # Users
    fbuilder.name(:standard_user, FactoryGirl.create(:user))

    # Worlds
    @nyc =
      World.build_from_shapefile(
        "lib/data/shapefiles/nyc/region",
        "BoroCD" => "name")
    @nyc.name = "NYC"
    @nyc.generate_blocks(500)
    @nyc.save!

    @miami =
      World.build_from_shapefile("lib/data/shapefiles/holed_square/region")
    @miami.name = "Miami"
    @miami.generate_blocks(2)
    @miami.save!
  end
end
