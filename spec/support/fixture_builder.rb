FixtureBuilder.configure do |fbuilder|
  fbuilder.files_to_check += Dir["spec/factories/**/*.rb", "spec/support/fixture_builder.rb"]

  fbuilder.factory do
    # Users
    fbuilder.name(:standard_user, FactoryGirl.create(:user))

    # Worlds
    @nyc = World.build_from_shapefile(
      "/Users/dimroc/workspace/new-block-city/lib/data/shapefiles/nyc/region.shp",
      "BoroCD" => "name")
    @nyc.name = "NYC"
    @nyc.generate_blocks(3000)
    @nyc.save!
  end
end
