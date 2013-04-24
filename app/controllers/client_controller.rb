class ClientController < ApplicationController
  before_filter :ensure_client_api_token
  before_filter :set_default_format
  respond_to :json

  rescue_from ::CanCan::AccessDenied do
    render :text => "You do not have access to this service", :status => :forbidden
  end

  rescue_from ::NotFoundError do |exception|
    render :text => exception, :status => :not_found
  end

  private

  def ensure_client_api_token
    raise ::CanCan::AccessDenied unless request.headers["NBC_SIGNATURE"] == 'yicceHasFatcowJemIvRurwojidfaitt'
  end

  def set_default_format
    request.format = 'json'
  end
end
