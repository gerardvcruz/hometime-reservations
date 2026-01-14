class ReservationDeserializer
  def initialize(params)
    @reservation = Reservation.new
    # flatten top level reservation hash if exists
    @params = params.merge(params.delete("reservation") || {})
    @params_keys = @params.keys - ["controller", "action"]
    @external_api_json_files = Dir["#{Rails.root}/lib/external_api_json/*.json"].each { |x| File.file?("lib/#{x}") }
  end

  def deserialize!
    external_api_json_file = find_external_json_api_file
    raise StandardError.new "API not supported" if external_api_json_file.nil?

    # preload the attributes that are mapped in the external json ref
    @external_api_json.each do |payload_key, model_attr|
      if (@reservation.respond_to?(model_attr))
        @reservation[:"#{model_attr}"] = @params[payload_key]
      end
    end

    external_api = File.basename(external_api_json_file, ".json")
    @reservation = public_send("parse_" + external_api)
  end

  def find_external_json_api_file
    @external_api_json_files.find do |external_api_json_file|
      @external_api_json = JSON.parse(File.read(external_api_json_file))
      (@params_keys - @external_api_json.keys).length == 0
    end
  end

  def parse_airbnb
    @reservation.guest_details = {
      "adults": @params[:adults],
      "children": @params[:children],
      "infants": @params[:infants],
      "total": @params[:adults] + @params[:children] + @params[:infants]
    }

    @reservation.guest = Guest.new(
      email: @params[:guest][:email],
      first_name: @params[:guest][:first_name],
      last_name: @params[:guest][:last_name],
      phone_numbers: [@params[:guest][:phone]]
    )

    @reservation
  end

  def parse_booking_com
    @reservation.guest_details = {
      "adults": @params[:guest_details][:number_of_adults],
      "children": @params[:guest_details][:number_of_children],
      "infants": @params[:guest_details][:number_of_infants],
      "total": @params[:guest_details][:number_of_adults] +
        @params[:guest_details][:number_of_children] +
        @params[:guest_details][:number_of_infants]
    }

    @reservation.guest = Guest.new(
      email: @params[:guest_email],
      first_name: @params[:guest_first_name],
      last_name: @params[:guest_last_name],
      phone_numbers: @params[:guest_phone_numbers]
    )

    @reservation
  end
end
