require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'title' do
    let!(:miso_ramen) { create :recipe, title: '味噌ラーメンの作り方', body: '味噌ラーメンの作り方です。', updated_at: 6.years.ago }
    let!(:miso_soup) { create :recipe, title: '味噌汁', body: '味噌汁の作り方です。', updated_at: 5.months.ago }
    let!(:miso_katsudon) { create :recipe, title: '味噌カツ丼', body: '味噌カツ丼の作り方です。', updated_at: 4.weeks.ago }
    let!(:miso_udon) { create :recipe, title: '味噌煮込みうどん', body: '味噌煮込みうどんの作り方です。', updated_at: 3.days.ago }
    let!(:miso) { create :recipe, title: '味噌', body: 'みその作り方です。', updated_at: 2.hours.ago }
    let!(:tonkotsu_ramen) { create :recipe, title: '豚骨ラーメン', body: '豚骨ラーメンの作り方です。', updated_at: 1.minutes.ago }

    it 'is in ascending order of updated_at' do
      title_q = { title_has_every_term: '味噌', s: { '0' => { name: 'updated_at', dir: 'asc' } } }
      expect(Recipe.ransack(title_q).result.map(&:id)).to eq [miso_ramen.id, miso_soup.id, miso_katsudon.id, miso_udon.id, miso.id]
    end

    it 'is in descending order of updated_at' do
      title_q = { title_has_every_term: '味噌', s: { '0' => { name: 'updated_at', dir: 'desc' } } }
      expect(Recipe.ransack(title_q).result.map(&:id)).to eq [miso.id, miso_udon.id, miso_katsudon.id, miso_soup.id, miso_ramen.id]
    end
  end
end
