# encoding: UTF-8
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  twitter_id :string(255)
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  username   :string(255)
#


require 'spec_helper'

describe User do
  
  before { @user = User.new(name: 'Ejemplo', username: 'ejemplo', email: 'ejemplo@ejemplo.com', avatar: 'url_a_imagen', twitter_id: 1) }
  
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:avatar) }
  it { should respond_to(:twitter_id) }
  
  it { should be_valid }
  
  describe "cuando el nombre está vacío" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  describe "cuando el username está vacío" do
    before { @user.username = " " }
    it { should_not be_valid }
  end
  
  describe "cuando el email está vacío" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "cuando el twitter_id está vacío" do
    before { @user.twitter_id = " " }
    it { should_not be_valid }
  end
  
  describe "con email repetido" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }
  end
  
  describe "con username repetido" do
    before do
      user_with_same_username = @user.dup
      user_with_same_username.save
    end

    it { should_not be_valid }
  end
  
  describe "con twitter_id repetido" do
    before do
      user_with_same_twitter_id = @user.dup
      user_with_same_twitter_id.save
    end

    it { should_not be_valid }
  end
end
