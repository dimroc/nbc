describe "regionsController", ->
  regionsController = null
  nyc = Fixtures.Regions.nyc
  beforeEach ->
    initializeSpine()
    regionsController = new App.RegionsController()

  describe "with spine initialized", ->
    describe "show", ->
      it "should render the region", ->
        output = regionsController.show.change(nyc.slug)
        $output = $(output)
        expect($output.find("p").text()).toContain(nyc.name)
