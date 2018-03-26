json.data do
  json.array! @tweets do |tweet|
    json.(tweet, :id, :description)
  end
end
