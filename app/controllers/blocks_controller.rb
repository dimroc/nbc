class BlocksController < ApiController
  before_filter :fetch_current_point
  load_resource :world

  def index
    if @current_point
      current_block = @world.blocks.near(@current_point).limit(1).first
      raise NotFoundError unless current_block.region.contains? @current_point
      respond_with [current_block]
    else
      respond_with @world.blocks
    end
  end

  private

  def fetch_current_point
    latitude = params[:latitude]
    longitude = params[:longitude]

    if latitude && longitude
      longlat = Mercator::FACTORY.point(longitude,latitude)
      @current_point = longlat.projection
    end
  end
end
