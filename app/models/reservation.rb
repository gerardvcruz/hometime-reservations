class Reservation < ApplicationRecord
  enum :status, [:new, :accepted, :cancelled]
end
