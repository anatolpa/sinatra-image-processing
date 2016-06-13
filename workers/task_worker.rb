class TaskWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'images'

  def perform(id)
    task        = Task.find id
    task.status = 'process'
    task.save!
    task.process_image!

    task.status = 'done'
    task.save!

    if task.callback_url
      options = {
          body: {
              task: task
          }
      }
      HTTParty.post(task.callback_url, options)
    end
  end
end
