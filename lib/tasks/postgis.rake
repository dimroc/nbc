namespace :postgis do
  def gis_database_name
    database_name = Rails.configuration.database_configuration["postgis"]["database"]
  end

  desc "Convert regular pg db to support PostGIS"
  task :convert_db, [:database_name] do |t, args|
    args.with_defaults(database_name: gis_database_name)

    puts "Converting #{args.database_name}..."

    `psql -d #{args.database_name} -f /usr/local/share/postgis/postgis.sql`
    `psql -d #{args.database_name} -f /usr/local/share/postgis/postgis_comments.sql`
  end

  desc "Populate PostGIS db with shape file. Default shapefile = NYC"
  task :import_shp, [:database_name] do |t, args|
    # Import the shape file
    # When running ignore the following errors:
    # ERROR:  column not found in geometry_columns table
    # ERROR:  table "nyc_geography" does not exist

    args.with_defaults(database_name: gis_database_name, shapefile: "public/shapefiles/nyc/regions")

    puts "Importing #{args.shapefile} to #{args.database_name}..."

    `shp2pgsql -d #{args.shapefile} nyc_geography | psql -d #{args.database_name}`
  end
end
