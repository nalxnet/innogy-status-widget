require 'faraday'
require 'faraday_middleware'

conn = Faraday.new(:url => 'https://www.rwe-mobility.com', :headers => { 'Accept' => 'application/json' }) do |conn|
  conn.response :json, :content_type => /\bjson$/
  conn.adapter Faraday.default_adapter
end


SCHEDULER.every '30m', :first_in => 0 do |job|
  response_cp1 = conn.get '/charging/api/v2/charge-point/my-chargepoint-id-1/'
  send_event("innogy-cp-1", cp_state: response_cp1.body["charger"]["chargePoints"]["evseStatus"])

  response_cp2 = conn.get '/charging/api/v2/charge-point/my-chargepoint-id-2/'
  send_event("innogy-cp-2", cp_state: response_cp2.body["charger"]["chargePoints"]["evseStatus"])
end
