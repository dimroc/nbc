class App.Neighborhood extends App.Model
  @configure 'Neighborhood', 'id', 'name', 'borough', 'slug', 'geometry'
  @extend Spine.Model.Ajax
  @url: "#{Constants.apiBasePath}/neighborhoods"

  meshes: ->
    App.MeshFactory.generateFromGeoJson(@geometry)
