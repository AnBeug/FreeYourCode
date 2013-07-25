require 'sinatra'

app = Sinatra.new do
  configure do
    set :sessions, true
    set :logging, true
    set :public_folder, Proc.new { "./public" }
    set :views, './views'
  end

  configure(:development) do
    set :dump_errors, true
    set :show_exceptions, true
  end

  configure(:production) do
    require 'newrelic_rpm'
  end

  get '/' do
    erb :index
  end
end

app.run!
