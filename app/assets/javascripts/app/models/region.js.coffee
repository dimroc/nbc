class App.Region extends App.Model
  @configure 'Region', 'name'
  @extend Spine.Model.Ajax

  validate: ->
    @errors = {}
    @appendErrors(name: "Name is required") unless @name
    @appendErrors(slug: "slug is required") unless @slug
