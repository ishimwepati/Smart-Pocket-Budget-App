require 'rails_helper'

RSpec.describe User, type: :model do
  context 'attribute name' do
    it 'is valid with an existing name' do
      expect(User.new(name: 'Tom', email: 'tom@example.com', password: 'topsecret')).to be_valid
    end

    it 'is not valid with a blank name' do
      expect(User.new(name: nil, email: 'tom@example.com', password: 'topsecret')).to_not be_valid
    end

    it 'is not valid with name of more than 36 characters' do
      expect(User.new(name: 'A' * 37, email: 'tom@example.com', password: 'topsecret')).to_not be_valid
    end
  end

  context 'attribute email' do
    it 'is valid with an existing email' do
      expect(User.new(name: 'Tom', email: 'tom@example.com', password: 'topsecret')).to be_valid
    end

    it 'is not valid with a blank email' do
      expect(User.new(name: 'Tom', password: 'topsecret')).to_not be_valid
    end

    it 'is not valid with email of a wrong format' do
      expect(User.new(name: 'A' * 37, email: 'tomexample.com', password: 'topsecret')).to_not be_valid
    end
  end

  context 'attribute the actual password' do
    it 'is valid with an existing password' do
      expect(User.new(name: 'Tom', email: 'tom@example.com', password: 'topsecret')).to be_valid
    end

    it 'is not valid with a blank password' do
      expect(User.new(name: 'Tom', email: 'tom@example.com')).to_not be_valid
    end

    it 'is not valid with a password that is less than 6 characters' do
      expect(User.new(name: 'A' * 37, email: 'tomexample.com', password: 'topt')).to_not be_valid
    end
  end
end
