class RegionsController < ApiController
  before_filter :fetch_world

  def index
    respond_with(Region.where(world_id: @world.id))
  end

  private

  def fetch_world
    @world = World.find(params[:world_id])
  end
end
