class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def move_to_cache
    true
  end

  def move_to_store
    true
  end

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end

  def cache_dir
    "tmp/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
  end
end