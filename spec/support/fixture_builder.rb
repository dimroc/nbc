FixtureBuilder.configure do |fbuilder|
  fbuilder.files_to_check += Dir["spec/factories/**/*.rb", "spec/support/fixture_builder.rb"]

  fbuilder.factory do
    # Users
    fbuilder.name(:standard_user, FactoryGirl.create(:user))

    # Neighborhoods
    Loader::Neighborhood.from_shapefile(
      Rails.root.join("lib/data/shapefiles/neighborhoods/region.shp").to_s)

    # Worlds
    @nyc = Loader::World.from_shapefile(
      Rails.root.join("lib/data/shapefiles/nyc/region.shp").to_s,
      "BoroCD" => "name")
    @nyc.name = "NYC"
    @nyc.regenerate_blocks(3000)
    @nyc.save!
  end
end
