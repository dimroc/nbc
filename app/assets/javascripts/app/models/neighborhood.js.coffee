class App.Neighborhood extends App.Model
  @configure 'Neighborhood', 'id', 'name', 'borough', 'slug', 'geometry'
  @extend Spine.Model.Ajax
  @url: "#{Constants.apiBasePath}/neighborhoods"

  @resetSelected: (neighborhood) ->
    App.Neighborhood.selected = neighborhood

  meshes: ->
    @_meshes = @_meshes || App.MeshFactory.generateFromGeoJson(@geometry)
    if App.Neighborhood.selected && @id == App.Neighborhood.selected.id
      _(@_meshes).each((mesh) ->
        mesh.material.color = new THREE.Color(0xFF0000))

    @_meshes
