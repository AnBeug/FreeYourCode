ENV['DATABASE_URL'] ||= "postgres://postgres:@localhost/free_your_code_#{ENV['RACK_ENV']}"
db = URI.parse(ENV['DATABASE_URL'])

$DB_SETTINGS = {
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8',
  :pool     => 10,
  :port     => db.port,
}

ActiveRecord::Base.establish_connection($DB_SETTINGS)

ActiveRecord::Base.include_root_in_json = false

class App < Sinatra::Base
  configure do
    use ActiveRecord::IdentityMap::Middleware
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
  end

  configure :development, :production do
    before do
      ActiveRecord::IdentityMap.clear
    end
  end

  configure :production do
    ActiveRecord::Base.logger = (ENV['ACTIVE_RECORD_LOGGING'].present? ? Logger.new(STDOUT) : nil)
  end

  configure :development do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end
