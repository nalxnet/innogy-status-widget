require "net/http"
require "json"

chargepoint1 = "XX-1234-5"
chargepoint2 = "YY-6789-0"

SCHEDULER.every '10m', :first_in => 0 do |job|
  uri_cp1 = URI('https://www.rwe-mobility.com/charging/api/v2/charge-point/#{chargepoint1}/')
  raw_cp1 = Net::HTTP.get(uri)
  data_cp1 = JSON.parse raw_cp1

  uri_cp2 = URI('https://www.rwe-mobility.com/charging/api/v2/charge-point/#{chargepoint2}/')
  raw_cp1 = Net::HTTP.get(uri)
  data_cp1 = JSON.parse raw_cp1

  send_event "innogy-cp", {
    cp1_id: data_cp1["charger"]["chargePoints"]["name"],
    cp1_state: data_cp1["charger"]["chargePoints"]["evseStatus"],
    cp2_id: data_cp1["charger"]["chargePoints"]["name"],
    cp2_state: data_cp2["charger"]["chargePoints"]["evseStatus"]
  }
end
