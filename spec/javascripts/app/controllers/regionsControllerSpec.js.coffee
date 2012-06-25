describe "regionsController", ->
  regionsController = null
  nyc = null

  beforeEach ->
    initializeSpine()
    regionsController = new App.RegionsController()
    nyc = Fixtures.nyc

  describe "with spine initialized", ->
    describe "show", ->
      it "should render the region", ->
        output = regionsController.show.change(nyc.slug)
        $output = $(output)
        expect($output.find("p").text()).toContain(nyc.name)
