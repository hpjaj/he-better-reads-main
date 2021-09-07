class User < ApplicationRecord
  has_secure_password

  has_many :reviews, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  before_save :format_email

private

  def format_email
    self.email = email.downcase.strip
  end
end
