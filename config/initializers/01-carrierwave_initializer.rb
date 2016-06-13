CarrierWave.configure do |config|
  config.root = File.join(Dir.pwd, 'uploads/')
  config.asset_host = ENV['ASSETS_HOST']
end