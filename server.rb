require 'sinatra'

app = Sinatra.new do
  configure do
    set :sessions, true
    set :logging, true
  end

  configure(:development) do
    set :dump_errors, true
    set :show_exceptions, true
  end

  get '/' do
    "It works!"
  end
end

app.run!
