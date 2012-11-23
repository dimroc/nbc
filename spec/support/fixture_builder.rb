FixtureBuilder.configure do |fbuilder|
  fbuilder.files_to_check += Dir["spec/factories/**/*.rb", "spec/support/fixture_builder.rb"]

  fbuilder.factory do
    # Users
    fbuilder.name(:standard_user, FactoryGirl.create(:user))

    # Neighborhoods
    Loader::Neighborhood.from_shapefile(
      Rails.root.join("lib/data/shapefiles/neighborhoods/region.shp").to_s)

    # Worlds
    @nyc = Loader::World.generate({
      name: "NYC",
      region_name_key: "BoroCD",
      inverse_scale: 3000,
      tolerance: 200
    }).save!
  end
end
