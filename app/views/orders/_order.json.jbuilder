json.ignore_nil!
order.visible_attributes.keys.each do |key|
  json.(order, key)
end

