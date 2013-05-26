class App.RoutingService
  @navigate: (neighborhood) ->
    Spine.Route.navigate("/boroughs/#{neighborhood.slug}")
