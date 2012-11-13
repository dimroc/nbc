ActiveRecord::Base.connection.execute(<<-SQL) #postgres specific
TRUNCATE neighborhoods RESTART IDENTITY;
SQL

NeighborhoodLoader.from_shapefile("lib/data/shapefiles/neighborhoods/region")
