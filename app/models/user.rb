class User < ApplicationRecord
  include ActiveModel::SecurePassword
  validates :username, :firstname, :lastname, :email, presence: true
  has_secure_password
  # has_and_belongs_to_many :user_submissions
end
