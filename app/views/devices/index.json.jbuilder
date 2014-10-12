json.array!(@devices) do |device|
  json.extract! device, :id, :login, :name
  json.url device_url(device, format: :json)
end
