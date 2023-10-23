class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable
  include ActiveModel::SecurePassword
  validates :email, presence: true
  # has_secure_password
  # has_and_belongs_to_many :user_submissions
end
