Factories.region = (options) ->
  factored_region = $.extend({}, {name: "Factored Region"}, options)
  factored_region.slug = _.str.dasherize(factored_region.name.toLowerCase())
  new App.Region(factored_region)
