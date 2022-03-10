require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(30) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(2000) }
    it { is_expected.to validate_presence_of(:recipe_image) }
  end

  describe 'validate_tag' do
    let(:alice) { create(:user, :no_image) }

    context 'when recipe has no tags' do
      it 'is valid' do
        recipe = build_stubbed(:recipe, tag_list: '', user: alice)
        expect(recipe).to be_valid
      end
    end

    context 'when recipe has 5 tags' do
      it 'is valid' do
        recipe = build_stubbed(:recipe, tag_list: '和風, 旬, 時短, かんたん, 手軽', user: alice)
        expect(recipe).to be_valid
      end
    end

    context 'when recipe has 6 tags' do
      it 'is invalid' do
        recipe = build_stubbed(:recipe, tag_list: '和風, 旬, 時短, かんたん, 手軽, 楽ちん', user: alice)
        expect(recipe).to be_invalid
        expect(recipe.errors).to be_of_kind(:tag_list, :too_many_tags)
      end
    end

    context 'when tag name length <= 20' do
      it 'is valid' do
        recipe = build_stubbed(:recipe, tag_list: 'a' * 20, user: alice)
        expect(recipe).to be_valid
      end
    end

    context 'when tag name length > 20' do
      it 'is invalid' do
        recipe = build_stubbed(:recipe, tag_list: 'a' * 21, user: alice)
        expect(recipe).to be_invalid
        expect(recipe.errors[:tag_list]).to include 'は20文字以内で入力してください'
      end
    end

    context 'when tag name has valid words' do
      let(:valid_tag_names) { %w[ひらがな ゔぁ ヴァ カタカナー 漢字 alphabet ALPHABET 12345] }

      it 'is valid' do
        recipe = build_stubbed(:recipe, tag_list: valid_tag_names[0..4].join(', '), user: alice)
        expect(recipe).to be_valid
        recipe = build_stubbed(:recipe, tag_list: valid_tag_names[5..].join(', '), user: alice)
        expect(recipe).to be_valid
      end
    end

    context 'when tag name has invalid words' do
      let(:invalid_tag_names) { %w[ｶﾀｶﾅ ｰ ａｌｐｈａｂｅｔ ＡＬＰＨＡＢＥＴ + / ／ * ? '] }

      it 'is invalid' do
        recipe = build_stubbed(:recipe, tag_list: invalid_tag_names[0..4].join(', '), user: alice)
        expect(recipe).to be_invalid
        expect(recipe.errors[:tag_list]).to include 'はひらがなまたは、全角のカタカナ、漢字、半角の英数字のみが使用できます'
        recipe = build_stubbed(:recipe, tag_list: invalid_tag_names[5..].join(', '), user: alice)
        expect(recipe).to be_invalid
        expect(recipe.errors[:tag_list]).to include 'はひらがなまたは、全角のカタカナ、漢字、半角の英数字のみが使用できます'
      end
    end
  end

  context 'when tag_list has duplicated words' do
    let(:alice) { create(:user, :no_image) }

    it 'dose not have duplicated tags' do
      recipe = create(:recipe, :no_image, tag_list: 'easy, easy, Easy', user: alice)
      expect(recipe.tags.map(&:name)).to eq %w[easy]
    end
  end

  describe 'others(count)' do
    let(:alice) { create(:user, :no_image) }
    let(:bob) { create(:user, :no_image) }
    let(:pizza) { create(:recipe, :no_image, user: alice) }
    let(:salad) { create(:recipe, :no_image, user: bob) }

    before { create_list(:recipe, 5, :no_image, user: alice) }

    it 'does not have irrelevant recipe' do
      expect(pizza.others(3)).not_to include salad
    end

    it 'does not have self' do
      expect(pizza.others(3)).not_to include pizza
    end

    context 'when second recipe in descending order of id' do
      it 'has correct recipes' do
        alice_recipe_ids = alice.recipes.ids.sort.reverse
        second_recipe = described_class.find(alice_recipe_ids[1])
        expect(second_recipe.others(3)[0].id).to eq alice_recipe_ids[0]
        expect(second_recipe.others(3)[1].id).to eq alice_recipe_ids[2]
        expect(second_recipe.others(3)[2].id).to eq alice_recipe_ids[3]
      end
    end

    context 'when fifth recipe in descending order of id' do
      it 'has correct recipes' do
        alice_recipe_ids = alice.recipes.ids.sort.reverse
        fifth_recipe = described_class.find(alice_recipe_ids[4])
        expect(fifth_recipe.others(3)[0].id).to eq alice_recipe_ids[0]
        expect(fifth_recipe.others(3)[1].id).to eq alice_recipe_ids[1]
        expect(fifth_recipe.others(3)[2].id).to eq alice_recipe_ids[2]
      end
    end

    context 'when other recipe does not exist' do
      it 'has no recipe' do
        expect(salad.others(3)).to eq []
      end
    end
  end
end
