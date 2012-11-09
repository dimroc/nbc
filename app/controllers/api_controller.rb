class ApiController < ApplicationController
  before_filter :set_default_format
  respond_to :json

  rescue_from ::CanCan::AccessDenied do
    render :text => "You do not have access to this service", :status => :forbidden
  end

  rescue_from ::NotFoundError do |exception|
    render :text => exception, :status => :not_found
  end

  private

  def set_default_format
    request.format = 'json'
  end
end
