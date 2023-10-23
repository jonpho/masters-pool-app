class FlightsController < ApplicationController
  before_action :authenticate_user!

  def index
    @flights = Flight.all
  end
end