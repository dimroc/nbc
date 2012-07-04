class BlocksController < ApiController
  before_filter :fetch_region, only: [:index]

  def index
    @blocks = @region.blocks
    respond_with @blocks
  end

  private

  def fetch_region
    @region = Region.find(params[:region_id])
  end
end
