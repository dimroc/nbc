ActiveRecord::Base.connection.execute(<<-SQL) #postgres specific
TRUNCATE neighborhoods RESTART IDENTITY;
SQL

Loader::Neighborhood.from_shapefile("lib/data/shapefiles/neighborhoods/region")
Loader::Neighborhood.write_json
Loader::Neighborhood.write_building_perimeters_json
