require './app'
require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'admin' && password == 'admin'
  end

  run Sidekiq::Web
end

run HomeWork