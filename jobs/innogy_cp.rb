require "net/http"
require "json"

SCHEDULER.every '10m', :first_in => 0 do |job|
  data_cp = get_chargepoint_data '12345678-0my0-uuid-abcd-1234567890ab'

  send_event "innogy-cp", {
    cp1_id: get_chargepoint_name(data_cp, 0),
    cp1_state: get_chargepoint_state(data_cp, 0),
    cp2_id: get_chargepoint_name(data_cp, 1),
    cp2_state: get_chargepoint_state(data_cp, 1),
    charger_state: get_charger_state(data_cp)
  }
end

def get_chargepoint_data(id)
  query = {
    "operationName" => "GetChargeStation",
    "variables" => {
      "uuids" => [
        id
      ],
      "userEmaids" => []
    },
    "query" => "query GetChargeStation($uuids: [String!], $userEmaids: [String]) { chargeStationsV2(uuids: $uuids userEmaids: $userEmaids) { name chargePoints { name evseStatus }}}"
  }.to_json

  uri = URI("https://api.services-emobility.com/bff/echarge/graphql")
  req = Net::HTTP::Post.new(uri, initheader = {'Content-Type' =>'application/json'})
  req.basic_auth("ECHARGE_API_USR", "KJRzxoC1nv!")
  req.body = "#{query}"

  res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
    http.request(req)
  end

  return JSON.parse res.body
end

def get_chargepoint_name(data, idx)
  return data.dig "data", "chargeStationsV2", 0, "chargePoints", idx, "name"
end

def get_chargepoint_state(data, idx, raw=false)
  raw_data = data.dig "data", "chargeStationsV2", 0, "chargePoints", idx, "evseStatus"
  if raw
    return raw_data
  end

  # translate as you like or just return raw status
  case raw_data
  when "AVAILABLE"
    return "FREI"
  when "OCCUPIED"
    return "BELEGT"
  when "OUT_OF_SERVICE"
    return "DEFEKT"
  else
    return "UNBEKANNT"
  end
end

def get_charger_state(data)
  cp1 = get_chargepoint_state(data, 0, true)
  cp2 = get_chargepoint_state(data, 1, true)

  if cp1 == "AVAILABLE" && cp2 == "AVAILABLE"
    return "AVAILABLE"
  elsif cp1 == "AVAILABLE" || cp2 == "AVAILABLE"
    return "PART_AVAILABLE"
  elsif cp1 == "OCCUPIED" || cp2 == "OCCUPIED"
    return "OCCUPIED"
  elsif cp1 == "OUT_OF_SERVICE" || cp2 == "OUT_OF_SERVICE"
    return "OUT_OF_SERVICE"
  else
    return "UNKNOWN"
  end

end
