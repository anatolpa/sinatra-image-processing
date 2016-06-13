class TaskSerializer <  ActiveModel::Serializer
  attributes :id, :operation, :status, :params, :callback_url, :image

  def root
    false
  end

  def id
    object.id.to_s
  end

  def image
    object.image.url
  end
end