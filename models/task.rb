class Task
  include Mongoid::Document

  field :operation, type: String
  field :status, type: String, default: 'new'
  field :params, type: String
  field :callback_url, type: String

  validates :operation, inclusion: {in: ['blur', 'negate', 'rotate', 'contrast']}
  validates :status, inclusion: {in: ['new', 'process', 'done']}
  validate :check_image

  mount_uploader :image, ImageUploader

  def process_image!
    image.manipulate! do |img|
      img.send(operation.to_sym, params)
      img = yield(img) if block_given?
      img
    end
  end

  private
  def check_image
    if image.url.nil?
      errors.add(:image, 'invalid image url')
    end
  end
end