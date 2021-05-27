require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  it 'is valid with a username, email and password' do
    expect(@user).to be_valid
  end

  it 'is invalid without a username' do
    @user.username = ''
    expect(@user).to be_invalid
  end

  it { is_expected.to validate_presence_of(:username) }

end
