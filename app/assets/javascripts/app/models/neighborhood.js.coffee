class App.Neighborhood extends App.Model
  @configure 'Neighborhood', 'id', 'name', 'borough', 'slug', 'geometry'
  @extend Spine.Model.Ajax
  @url: "#{Constants.apiBasePath}/neighborhoods"

  @fetchFromStatic: ->
    $.getJSON("#{Constants.staticBasePath}/neighborhoods.json").
      done((data) -> App.Neighborhood.refresh(data, {clear: true}))

  neighbors: ->
    for id in @neighborIds
      App.Neighborhood.find(id)
