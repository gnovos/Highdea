require 'rubygems'
require 'sinatra'
require 'json'
#require 'sinatra/contrib/all'

configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot

  # TIP:  You can get you database information
  #       from ENV['DATABASE_URI'] (see /env route below)
end

def respond(body)
  [200, {
      'X-Strain' => 'indica'
  }, body.is_a?(String) ? body : body.to_json]
end

get '/api/:version/:method' do |version, method|
  respond(
      version: version,
      method: method,
      data: [
        {
            user: 'test',
            idea: 'What if we made an app to share ideas while high?'
        },
        {
            user: 'test',
            idea: 'Test Idea?'
        },
        {
            user: 'test',
            idea: 'Yep, andother Test Idea.'
        },
        {
            user: 'test',
            idea: 'Magic 8-ball says: Outlook Looks Good'
        }
      ]
  )
end

get '/self/env' do
   respond <<-HTML

<dl>
#{ ENV.map { |name, value| "<dt>#{name}</dt>\n<dd>'#{value}'</dd><br/>\n" }.join }
</dl>

  HTML
end

get '/self/code' do
  respond <<-HTML
<pre>
#{Rack::Utils.escape_html(File.read(__FILE__))}
</pre>
  HTML
end