class User < ApplicationRecord
  include ActiveModel::SecurePassword
  validates :username, :firstname, :lastname, :email, presence: true
  has_secure_password
end
