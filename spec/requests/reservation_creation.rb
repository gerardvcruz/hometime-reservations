require "rails_helper"

RSpec.describe "Reservation Creation", type: :request do
  it "creates a reservation from airbnb" do
    airbnb_params = {
      "start_date": "2021-03-12",
      "end_date": "2021-03-16",
      "nights": 4,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "id": 1,
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone": "639123456789",
        "email": "wayne_woodbridge@bnb.com"
      },
      "currency": "AUD",
      "payout_price": "3800.00",
      "security_price": "500",
      "total_price": "4500.00"
    }
    headers = { "ACCEPT" => "application/json" }
    post "/reservations", params: airbnb_params, headers: headers

    response_body = JSON.parse(response.body)

    expect(response).to have_http_status(:created)
    expect(response_body["reservation"]["start_date"]).to eq(airbnb_params[:start_date])
    expect(response_body["reservation"]["end_date"]).to eq(airbnb_params[:end_date])
    expect(response_body["guest"]["email"]).to eq(airbnb_params[:guest][:email])
  end

  it "creates a reservation from booking.com" do
    booking_com_params = {
      "reservation": {
        "start_date": "2021-03-12",
        "end_date": "2021-03-16",
        "expected_payout_amount": "3800.00",
        "guest_details": {
          "localized_description": "4 guests",
          "number_of_adults": 2,
          "number_of_children": 2,
          "number_of_infants": 0
        },
        "guest_email": "wayne_woodbridge@bnb.com",
        "guest_first_name": "Wayne",
        "guest_id": 1,
        "guest_last_name": "Woodbridge",
        "guest_phone_numbers": [
          "639123456789",
          "639123456789"
        ],
        "listing_security_price_accurate": "500.00",
        "host_currency": "AUD",
        "nights": 4,
        "number_of_guests": 4,
        "status_type": "accepted",
        "total_paid_amount_accurate": "4500.00"
      }
    }
    headers = { "ACCEPT" => "application/json" }
    post "/reservations", params: booking_com_params, headers: headers

    response_body = JSON.parse(response.body)

    expect(response).to have_http_status(:created)
    expect(response_body["reservation"]["start_date"]).to eq(booking_com_params[:reservation][:start_date])
    expect(response_body["reservation"]["end_date"]).to eq(booking_com_params[:reservation][:end_date])
    expect(response_body["guest"]["email"]).to eq(booking_com_params[:reservation][:guest_email])
  end

  it "returns API not supported when supplied with unknown JSON" do
    new_booking_service_params = {
      "start_date": "2021-03-12",
      "end_date": "2021-03-16",
      "payout_amount": "3800.00",
      "guest_email": "wayne_woodbridge@bnb.com",
      "guest_first_name": "Wayne",
      "guest_id": 1,
      "guest_last_name": "Woodbridge",
      "guest_phone_numbers": [
        "639123456789",
        "639123456789"
      ],
    }
    headers = { "ACCEPT" => "application/json" }
    post "/reservations", params: new_booking_service_params, headers: headers

    response_body = JSON.parse(response.body)

    expect(response).to have_http_status(:bad_request)
    expect(response_body["error"]).to eq("API not supported")
  end
end
