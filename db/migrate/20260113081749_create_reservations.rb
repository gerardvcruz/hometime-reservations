class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.references :guest, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.decimal :payout_price
      t.decimal :security_price
      t.decimal :total_price
      t.integer :currency
      t.json :guest_details
      t.integer :status

      t.timestamps
    end
  end
end
