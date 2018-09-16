require 'twitter'
require './class_cancellation.rb'


client = Twitter::REST::Client.new do |config|
  config.consumer_key         = ENV['MY_CONSUMER_KEY']
  config.consumer_secret      = ENV['MY_CONSUMER_SECRET']
  config.access_token         = ENV['MY_ACCESS_TOKEN']
  config.access_token_secret  = ENV['MY_ACCESS_TOKEN_SECRET']
end

tweet_information(client)
