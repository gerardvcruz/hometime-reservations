class ReservationsController < ApplicationController
  before_action :deserialize_params

  def create
    if @reservation.save
      render json: {
        reservation: @reservation,
        guest: @guest
      }, status: 201
    else
      render json: @reservation.errors, status: 400
    end
  end

  private
  def deserialize_params
    begin
      @reservation = Reservation.deserialize_params(params.to_unsafe_h)
      @guest = Guest.find_or_register_by_reservation(@reservation)

      if @guest.id
        @reservation.guest_id = @guest.id
      else
        render json: @guest.errors, status: 400
      end
    rescue StandardError => e
      render json: { error: e }, status: 400
    end
  end
end
