(function() {

  Factories.region = function(options) {
    var factored_region;
    factored_region = $.extend({}, {
      name: "Factored Region"
    }, options);
    factored_region.slug = _.str.dasherize(factored_region.name.toLowerCase());
    return factored_region;
  };

}).call(this);
