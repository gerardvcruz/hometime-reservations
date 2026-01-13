class Reservation < ApplicationRecord
  enum :status, [:pending, :accepted, :cancelled]
  enum :currency, [:AUD, :PHP]

  belongs_to :guest

  def self.deserialize_params params
    reservation_deserializer = ReservationDeserializer.new(params)

    reservation = reservation_deserializer.deserialize!
  end
end
