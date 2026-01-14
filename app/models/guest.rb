class Guest < ApplicationRecord
  has_many :reservations

  def self.find_or_register_by_reservation(reservation)
    guest = Guest.find_or_create_by(email: reservation.guest.email) do |guest|
      guest.email = reservation.guest.email
      guest.first_name = reservation.guest.first_name
      guest.last_name = reservation.guest.last_name
      guest.phone_numbers = reservation.guest.phone_numbers
    end
  end
end
