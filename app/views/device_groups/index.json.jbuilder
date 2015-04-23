json.array!(@device_groups) do |device_group|
  json.extract! device_group, :id
  json.url device_group_url(device_group, format: :json)
end
