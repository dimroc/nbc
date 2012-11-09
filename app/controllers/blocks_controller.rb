class BlocksController < ApiController
  before_filter :fetch_current_point
  load_resource :world

  def index
    if @current_point
      respond_with @world.blocks.near(@current_point).limit(1)
    else
      respond_with @world.blocks
    end
  end

  private

  def fetch_current_point
    latitude = params[:latitude]
    longitude = params[:longitude]

    if latitude && longitude
      @current_point = Mercator.to_projected(Mercator::FACTORY.point(longitude,latitude))
    end
  end
end
