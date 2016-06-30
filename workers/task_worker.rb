class TaskWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'images'

  def perform(id)
    task = Task.find id
    task.process_image!

    if task.callback_url
      options = {
          body: {
              status:       task.status,
              result_image: task.image.url
          }
      }
      HTTParty.post(task.callback_url, options)
    end
  end
end
