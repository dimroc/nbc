class RegionsController < ApiController
  before_filter :fetch_region, only: [:update, :show, :destroy]

  def index
    @regions = Region.all
    respond_with(@regions)
  end

  def create
    @region = Region.new(params[:region])
    @region.save
    respond_with(@region)
  end

  def update
    @region.update_attributes(params[:region])
    respond_with(@region)
  end

  def show
    respond_with(@region)
  end

  def destroy
    @region.destroy
    respond_with(@region)
  end

  private

  def fetch_region
    @region = Region.find(params[:id])
  end
end
