class UserSerializer < ActiveModel::Serializer
  attributes(
    :id,
    :first_name,
    :last_name,
    :email,
    :token
  )

  def token
    @instance_options[:token]
  end
end
