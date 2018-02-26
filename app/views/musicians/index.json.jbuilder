json.musicians do
  json.array! @musicians, :id, :name, :begun_in, :description
end
