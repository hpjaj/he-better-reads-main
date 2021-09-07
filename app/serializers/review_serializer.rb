class ReviewSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :reviewable_type,
    :reviewable_id,
    :description,
    :rating,
    :created_at,
    :user
  )

  def user
    UserSerializer.new(object.user)
  end
end
