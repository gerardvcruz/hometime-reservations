class Reservation < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date, message: "can't be before or equal to the start date" }
  validates :payout_price, presence: true, numericality: true
  validates :security_price, presence: true, numericality: true
  validates :total_price, presence: true, numericality: true

  enum :status, [:pending, :accepted, :cancelled]
  enum :currency, [:AUD, :PHP]

  belongs_to :guest

  def self.deserialize_params params
    reservation_deserializer = ReservationDeserializer.new(params)

    reservation = reservation_deserializer.deserialize!
  end
end
