class BookSerializer < ActiveModel::Serializer
  attributes(
    :uuid,
    :title,
    :description,
    :publish_date,
    :rating,
    :slug,
    :average_rating,
    :reviews_count,
    :author
  )

  def id
    nil
  end

  def slug
    object.title.parameterize
  end

  def average_rating
    return if object.average_rating.nil?

    object.rating_to_the_nearest(0.5)
  end

  def author
    AuthorSerializer.new(object.author)
  end
end
