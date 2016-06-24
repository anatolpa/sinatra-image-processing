#\ -p 8080
require './app'

map '/sidekiq' do
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'admin' && password == 'admin'
  end

  run Sidekiq::Web
end

run ImageProcessor
