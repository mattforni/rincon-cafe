json.ignore_nil!
user.visible_attributes.keys.each do |key|
  json.(user, key)
end

