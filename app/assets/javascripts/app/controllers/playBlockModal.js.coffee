class App.Controller.PlayBlockModal extends Spine.Controller
  className: "blockPlayer"

  @instance: ->
    singleton

  constructor: (block) ->
    super
    App.ModalElementService.configure(@el)

  render: (block) ->
    if block.video.url
      @html @view("playBlockModal")(video: block.video)
    else
      @html @view("noPlayBlockModal")()

  play: (block) ->
    @render(block)
    @$el.modal('show').css(
       'width': -> '660px'
       'height': -> '500px'
       'margin-left': -> return -($(this).width() / 2))

singleton = new App.Controller.PlayBlockModal()

