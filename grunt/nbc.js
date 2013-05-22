var BuildingExporter = require('./buildingExporter')

module.exports = function(grunt) {
  grunt.registerTask('exportBuildings', 'Converts Building GeoJSON to THREEjs', function() {
    var buildingExporter = new BuildingExporter();
    buildingExporter.parseAll();
  });
};
