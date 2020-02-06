require "net/http"
require "json"

SCHEDULER.every '10m', :first_in => 0 do |job|
  data_cp1 = get_chargepoint_data 'XX-1234-5'
  data_cp2 = get_chargepoint_data 'YY-6789-0'

  send_event "innogy-cp", {
    cp1_id: get_chargepoint_name(data_cp1),
    cp1_state: get_chargepoint_state(data_cp1),
    cp2_id: get_chargepoint_name(data_cp2),
    cp2_state: get_chargepoint_state(data_cp2),
    charger_state: get_charger_state(data_cp1, data_cp2)
  }
end

def get_chargepoint_data(id)
  uri = URI("https://www.rwe-mobility.com/charging/api/v2/charge-point/#{id}/")
  raw = Net::HTTP.get(uri)
  return JSON.parse raw
end

def get_chargepoint_name(data)
  return data["charger"]["chargePoints"]["name"]
end

def get_chargepoint_state(data, raw=false)
  raw_data = data["charger"]["chargePoints"]["evseStatus"]
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

def get_charger_state(data1, data2)
  cp1 = get_chargepoint_state(data1, true)
  cp2 = get_chargepoint_state(data2, true)

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
