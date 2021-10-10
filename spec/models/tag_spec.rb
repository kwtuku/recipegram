require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { is_expected.to validate_length_of(:name).is_at_most(20) }

  it 'is saved as lower case' do
    tag = described_class.create(name: 'EASY')
    expect(tag.name).to eq 'easy'
  end
end
