Factories.region = (options) ->
  factored_region = $.extend({}, {name: "Factored Region"}, options)
  factored_region.slug = _.str.dasherize(factored_region.name.toLowerCase())
  factored_region
