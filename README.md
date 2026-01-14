## Reservation API with Guest registration

### External API Reference Objects
This API uses external JSON object references found in `lib/external_api_json` to map the external API's JSON keys to the Rails API's Reservation Model attributes.

This might need some versioning or checking of the external API's JSON object payload for changes.

When a new service is added, a new external JSON object reference must be added as well.

Sample AirBnB JSON request:
```json

{
  "start_date": "start_date",
  "end_date": "end_date",
  "nights": "",
  "guests": "guest_details.total",
  "adults": "guest_details.adults",
  "children": "guest_details.children",
  "infants": "guest_details.infants",
  "guest": "",
  "payout_price": "payout_price",
  "security_price": "security_price",
  "total_price": "total_price",
  "currency": "currency",
  "status": "status"
}

```

### Setup
```
$ bundle
$ rails s
```

### Testing
```
$ rspec spec/requests/reservation_creation.rb
```
> default Rails model validations were not included in the spec as that would be redundant
