require 'sinatra'

app = Sinatra.new do
  get '/' do
    "It works!"
  end
end

app.run!
