require 'rubygems'
require 'sinatra'

configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end


HTTP_OK = 200
HEADERS = {
}

get '/api/:version/:call' do
  body = ""

  [HTTP_OK, HEADERS, body]
end

get '/senv' do
   ENV.inspect
end