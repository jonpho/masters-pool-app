require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'devise modules' do
    it 'includes database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end

    it 'includes lockable module' do
      expect(User.devise_modules).to include(:lockable)
    end
  end

  describe 'validations' do
    subject { described_class.new(email: 'test@example.com', password: 'password123') }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with an invalid email format' do
      subject.email = 'invalid_email'
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      described_class.create(email: 'test@example.com', password: 'password123')
      expect(subject).not_to be_valid
    end

    it 'is not valid with a short password' do
      subject.password = '12345'
      expect(subject).not_to be_valid
    end
  end

  describe 'user creation' do
    let(:user_params) do
      {
        username: 'johndoe',
        firstname: 'John',
        lastname: 'Doe',
        email: 'john.doe@example.com',
        password: 'SecurePassword123'
      }
    end

    it 'creates a user with all attributes' do
      user = User.create(user_params)
      expect(user).to be_persisted
      expect(user.username).to eq('johndoe')
      expect(user.firstname).to eq('John')
      expect(user.lastname).to eq('Doe')
      expect(user.email).to eq('john.doe@example.com')
    end

    it 'encrypts the password' do
      user = User.create(user_params)
      expect(user.encrypted_password).not_to be_nil
      expect(user.encrypted_password).not_to eq('SecurePassword123')
    end
  end

  describe 'authentication' do
    let(:user) { User.create(email: 'auth@example.com', password: 'password123') }

    it 'authenticates with correct password' do
      expect(user.valid_password?('password123')).to be true
    end

    it 'does not authenticate with incorrect password' do
      expect(user.valid_password?('wrongpassword')).to be false
    end
  end

  describe 'lockable behavior' do
    let(:user) { User.create(email: 'lockable@example.com', password: 'password123') }

    it 'has failed_attempts tracking' do
      expect(user).to respond_to(:failed_attempts)
      expect(user.failed_attempts).to eq(0)
    end

    it 'has unlock_token for account unlocking' do
      expect(user).to respond_to(:unlock_token)
    end

    it 'has locked_at timestamp' do
      expect(user).to respond_to(:locked_at)
    end
  end

  describe 'password recovery' do
    let(:user) { User.create(email: 'recovery@example.com', password: 'password123') }

    it 'can send reset password instructions' do
      expect(user).to respond_to(:send_reset_password_instructions)
    end

    it 'has reset_password_token field' do
      expect(user).to respond_to(:reset_password_token)
    end

    it 'has reset_password_sent_at field' do
      expect(user).to respond_to(:reset_password_sent_at)
    end
  end

  describe 'rememberable behavior' do
    let(:user) { User.create(email: 'remember@example.com', password: 'password123') }

    it 'has remember_created_at field' do
      expect(user).to respond_to(:remember_created_at)
    end
  end
end
