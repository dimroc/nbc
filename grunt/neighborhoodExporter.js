// Node REQUIRES
var THREE = require('three');
var _ = require('underscore');
var GeometryExporter = require('./geometryExporter');
var MeshFactory = require('./meshFactory');
var fs = require('fs');
var PATH = require('path');

// Constructor
var NeighborhoodExporter = function(options) {
  options = options || {};
  _.defaults(options, {
    inputPath: "./public/static/neighborhoods.json",
    outputPath: "./public/static/threejs/neighborhoods.json"
  });

  this.outputPath = options.outputPath;
  this.inputPath = options.inputPath;

  var dir = PATH.dirname(this.outputPath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }
};

_.extend(NeighborhoodExporter.prototype, {
  perform: function() {
    var neighborhoods = JSON.parse(fs.readFileSync(this.inputPath));

    var geoms = _(neighborhoods).map(function(n) {
      return MeshFactory.generateFromGeoJson(n.geometry, {ignoreLidFaces: true});
    });

    geoms = _(geoms).flatten();
    var mergedGeom = MeshFactory.mergeMeshes(geoms);

    var geomExporter = new GeometryExporter();
    var exported3js = geomExporter.parse(mergedGeom);

    fs.writeFileSync(this.outputPath, JSON.stringify(exported3js));
  }
});


module.exports = NeighborhoodExporter;
