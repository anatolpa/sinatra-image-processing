require 'rubygems'
require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'])

# require 'rack/protection'
require 'sidekiq/api'
require 'sidekiq/web'
require './uploaders/image_uploader'
require './models/task'
require './models/serializers/task_serializer'
require './workers/task_worker'

Dotenv.load
