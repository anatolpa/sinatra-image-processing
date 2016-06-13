require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/json'
require 'mongoid'
require 'dotenv'
require 'sinatra-initializers'
require 'carrierwave/mongoid'
require 'open-uri'
require 'active_model_serializers'
require 'will_paginate_mongoid'
require 'httparty'
require 'sidekiq'
require 'sidekiq/api'
require 'sidekiq/web'
require './uploaders/image_uploader'
require './models/task'
require './models/serializers/task_serializer'
require './workers/task_worker'

Dotenv.load

class HomeWork < Sinatra::Application
  register Sinatra::Initializers

  configure do
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
    set :public_folder, 'uploads'
  end

  get '/tasks' do
    param :page, Integer, default: 1
    param :limit, Integer, default: 20

    json Task.paginate(:page => params[:page], :per_page => params[:limit])
  end

  post '/tasks' do
    param :image, String, required: true
    param :operation, String, required: true, in: ['blur', 'negate', 'rotate', 'contrast']
    param :callback_url, String

    task = Task.new
    task.image = params[:image]
    task.operation = params[:operation]
    task.params = params[:params] if params[:params].present?
    task.callback_url = params[:callback_url] if params[:callback_url].present?
    task.save!
    TaskWorker.perform_async task.id
    json task
  end

  get '/tasks/:id' do
    json Task.find params[:id]
  end

  # errors

  error Sinatra::Param::InvalidParameterError do
    status 422
    json error: "Invalid parameter: '#{env['sinatra.error'].param}'. #{env['sinatra.error'].message}"
  end

  error Mongoid::Errors::DocumentNotFound do
    status 404
    json error: 'Not found'
  end

  error do
    json error: env['sinatra.error'].message
  end
end

