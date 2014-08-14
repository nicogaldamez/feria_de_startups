# encoding: UTF-8
# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  uid                   :string(255)
#  avatar                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  username              :string(255)
#  provider              :string(255)
#  description           :text
#  receive_notifications :boolean          default(TRUE)
#


require 'spec_helper'

describe User do
  
  before { @user = User.new(name: 'Ejemplo', username: 'ejemplo', email: 'ejemplo@ejemplo.com', avatar: 'url_a_imagen', uid: 1) }
  
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:avatar) }
  it { should respond_to(:uid) }
  it { should respond_to(:description) }
  it { should respond_to(:receive_notifications) }
  
  it { should be_valid }
  
  describe "por defecto recibe notificaciones" do
    before { @user.save }
    it { @user.receive_notifications.should be_true }
  end
  
  describe "cuando el nombre está vacío" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  describe "cuando el username está vacío" do
    before { @user.username = " " }
    it { should_not be_valid }
  end
  
  describe "cuando el uid está vacío" do
    before { @user.uid = " " }
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
  
  describe "con uid repetido" do
    before do
      user_with_same_uid = @user.dup
      user_with_same_uid.save
    end

    it { should_not be_valid }
  end
end
