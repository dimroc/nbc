ActiveRecord::Base.connection.execute(<<-SQL) #postgres specific
TRUNCATE neighborhoods RESTART IDENTITY;
SQL

Loader::Neighborhood.from_shapefile("lib/data/shapefiles/neighborhoods/region")
