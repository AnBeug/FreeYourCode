require 'sinatra'
require 'active_record'
require 'omniauth'
require 'omniauth-github'

ENV['RACK_ENV'] ||= 'development'

files = []
files.concat(Dir[File.join(File.dirname(__FILE__), 'config','**','*.rb')])
files.concat(Dir[File.join(File.dirname(__FILE__), 'models','**','*.rb')])
files.each do |file|
  require file
end

class App < Sinatra::Base
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
    # Enable multiple Heroku dynos to share sessions
    set :session_secret, ENV['SESSION_KEY']
  end

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET']
  end

  get '/' do
    erb :index
  end

  get '/auth/:name/callback' do
    auth = request.env["omniauth.auth"]

    user = User.find_or_initialize_by_uid(auth["uid"])
    user.update_attributes!({
      :name => auth["info"]["name"],
      :nickname => auth["info"]["nickname"],
      :email => auth["info"]["email"],
      :avatar_url => auth["info"]["image"],
    })

    session[:user_id] = user.id
    redirect '/'
  end

  # If user clicks "Deny this request"
  get '/auth/failure' do
    redirect '/'
  end

  helpers do
    def current_user
      @current_user ||= User.find(session[:user_id])  if session[:user_id]
    end
  end
end
