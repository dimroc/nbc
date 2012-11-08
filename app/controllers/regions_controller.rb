class RegionsController < ApiController
  load_resource :world

  def index
    respond_with(@world.regions)
  end
end
