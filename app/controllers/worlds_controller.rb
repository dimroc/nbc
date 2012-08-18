class WorldsController < ApiController
  def index
    respond_with(World.all)
  end

  def show
    respond_with(World.find(params[:id]))
  end
end
