class BlocksController < ApiController
  before_filter :load_current_point
  load_resource :world

  def index
    if @current_point
      # TODO: Create scope that orders by distance from point
      respond_with [@world.blocks.order(<<-SQL).first]
        ST_Distance('SRID=#{@current_point.srid};#{@current_point.as_text}', point) ASC
      SQL
    else
      respond_with @world.blocks
    end
  end

  private

  def load_current_point
    latitude = params[:latitude]
    longitude = params[:longitude]

    if latitude && longitude
      @current_point = Mercator.to_projected(Mercator::FACTORY.point(longitude,latitude))
    end
  end
end
