class App.Region extends App.Model
  @configure 'Region', 'id', 'name', 'slug'
  @extend Spine.Model.Ajax

  @hasMany 'blocks', "App.Block"

  validate: ->
    @errors = {}
    @appendErrors(name: "Name is required") unless @name
    @appendErrors(slug: "slug is required") unless @slug
