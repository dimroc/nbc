class Api::NeighborhoodsController < ApiController
  before_filter :fetch_current_point

  def index
    if @current_point
      respond_with Neighborhood.intersects(@current_point).first
    else
      respond_with Neighborhood.all
    end
  end
end
