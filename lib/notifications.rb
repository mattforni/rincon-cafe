require 'uri'
require 'net/http'
require 'net/https'

module Notifications
  def self.ios(user, message)
    return if user.udid.nil?

    data = {
        "deviceType": "ios",
        "deviceToken": user.udid,
        "channels": [
          "CafeQ"
        ],
        "data": {
          "alert": message,
          "sound": "default"
        }
    }.to_json

    uri = URI.parse("https://api.parse.com/1/push")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req['X-Parse-Application-Id'] = 'I90LbfQuYYVY9eggmU9ULhenz1q8r4xAi82udZk3'
    req['X-Parse-REST-API-Key'] = '11GJgVK5zTJNvNtlBcymYQNoWuAIjucDhipOnfe3'
    req.body = data
    res = https.request(req)
  end
end

