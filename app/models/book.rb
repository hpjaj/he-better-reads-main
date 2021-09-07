class Book < ApplicationRecord
  belongs_to :author

  validates :title, :description, presence: true
  validates :uuid, presence: true, uniqueness: true

  before_validation :initialize_uuid, on: :create

  def initialize_uuid
    new_uuid  = generate_uuid
    new_uuid  = generate_uuid until unique?(new_uuid)
    self.uuid = new_uuid
  end

private

  def unique?(new_uuid)
    return true unless Book.exists?(uuid: new_uuid)
  end

  def generate_uuid
    SecureRandom.uuid
  end
end
