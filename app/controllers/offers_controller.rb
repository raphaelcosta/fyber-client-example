class OffersController < ApplicationController
  before_filter :check_if_uid_is_present, only: :search

  def search
    api_response = fyber_api.fetch_offers(search_params)
    @offers = api_response.offers
  end

  private

  def check_if_uid_is_present
    redirect_to offers_path, alert: 'UID field is required' if search_params[:uid].blank?
  end

  def fyber_api
    @fyber_api ||= FyberApi::Client.new
  end

  def search_params
    params.require(:offers).permit(:uid, :pub0, :page)
  end
end
