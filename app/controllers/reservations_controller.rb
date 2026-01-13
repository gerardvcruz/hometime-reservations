class ReservationsController < ApplicationController
  before_action :deserialize_params

  def create
    if @reservation.save
      render json: @reservation, status: 200
    else
      render json: @reservation.errors, status: 400
    end
  end

  private
  def deserialize_params
    begin
      # rails automatically wraps the incoming payload with :reservation
      @reservation = Reservation.deserialize_params(params.to_unsafe_h)
    rescue StandardError => e
      render json: { error: e }, status: 400
    end
  end
end
