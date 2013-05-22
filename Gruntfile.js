require('./grunt/nbc.js');

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadTasks('grunt');

  // Default task(s).
  grunt.registerTask('default', ['exportBuildings']);
};
