ActiveRecord::Base.connection.execute(<<-SQL) #postgres specific
TRUNCATE zip_code_maps RESTART IDENTITY;
SQL

Socrata::Loader.new(File.read('db/data/ZipCodeMaps.json')).each do |row|
  ZipCodeMap.build_from_socrata(row).save!
end
