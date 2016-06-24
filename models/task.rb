class Task
  include Mongoid::Document

  OPERATIONS = ['blur', 'negate', 'rotate', 'contrast', 'resize']

  field :operation, type: String
  field :status, type: String, default: 'new'
  field :params, type: String
  field :callback_url, type: String

  validates :operation, inclusion: {in: OPERATIONS}
  validates :status, inclusion: {in: ['new', 'process', 'done']}
  validate :check_image

  mount_uploader :image, ImageUploader

  def process_image!
    self.status = 'process'
    self.save!
    image.manipulate! do |img|
      img.send operation.to_sym, self.params
    end
    self.status = 'done'
    self.save!
  end

  private
  def check_image
    if image.url.nil?
      errors.add(:image, 'invalid image url')
    end
  end
end