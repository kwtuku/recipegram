require 'rails_helper'

RSpec.describe 'Search', type: :model do
  describe '*_has_every_term' do
    before do
      create(:user, profile: 'ラーメン チャーハン ハンバーグ')
      create(:user, profile: 'ラーメン チャーハン')
      create(:user, profile: 'ラーメン ハンバーグ')
      create(:user, profile: 'ラーメン')
    end

    it 'escapes wildcards' do
      value = '_'
      expect(User.ransack(profile_has_every_term: value).result.size).to eq 0
      value = '%'
      expect(User.ransack(profile_has_every_term: value).result.size).to eq 0
    end

    context 'when value does not contain space' do
      it 'has correct result' do
        value = 'ラーメン'
        expect(User.ransack(profile_has_every_term: value).result.size).to eq 4
      end
    end

    context 'when value contains space' do
      it 'has correct result' do
        value = 'ラーメン ハンバーグ'
        expect(User.ransack(profile_has_every_term: value).result.size).to eq 2
      end
    end

    context 'when value contains full-width space' do
      it 'has correct result' do
        value = 'ラーメン　ハンバーグ'
        expect(User.ransack(profile_has_every_term: value).result.size).to eq 2
      end
    end

    context 'when value contains space and full-width space' do
      it 'has correct result' do
        value = 'ラーメン  チャーハン　ハンバーグ'
        expect(User.ransack(profile_has_every_term: value).result.size).to eq 1
      end
    end
  end

  describe 'search title' do
    let(:alice) { create(:user) }
    let(:miso_ramen) { create(:recipe, title: '味噌ラーメン', updated_at: 2.hours.ago, user: alice) }
    let(:shoyu_ramen) { create(:recipe, title: 'しょうゆラーメン', updated_at: 4.weeks.ago, user: alice) }
    let(:sio_ramen) { create(:recipe, title: '塩ラーメン', updated_at: 3.days.ago, user: alice) }
    let(:tonkotsu_ramen) { create(:recipe, title: '豚骨らーめん', updated_at: 2.days.ago, user: alice) }

    it 'is in descending order of updated_at' do
      title_query = { title_has_every_term: 'ラーメン', s: { '0' => { name: 'updated_at', dir: 'desc' } } }
      recipe_title_results = Recipe.ransack(title_query).result
      expected_results = [miso_ramen.id, sio_ramen.id, shoyu_ramen.id]
      expect(recipe_title_results.map(&:id)).to eq expected_results
    end

    context 'when sort by comments count' do
      before do
        users = create_list(:user, 3)
        create(:comment, recipe: shoyu_ramen, user: users.sample)
        create_list(:comment, 2, recipe: tonkotsu_ramen, user: users.sample)
        create_list(:comment, 4, recipe: miso_ramen, user: users.sample)
      end

      it 'is in descending order of comments count' do
        title_query = { title_has_every_term: 'ラーメン', s: { '0' => { name: 'comments_count', dir: 'desc' } } }
        recipe_title_results = Recipe.ransack(title_query).result
        expected_results = [miso_ramen.id, shoyu_ramen.id, sio_ramen.id]
        expect(recipe_title_results.map(&:id)).to eq expected_results
      end
    end

    context 'when sort by favorites count' do
      before do
        users = create_list(:user, 6)
        users.sample.favorites.create(recipe_id: shoyu_ramen.id)
        users.sample(3).each { |user| user.favorites.create(recipe_id: tonkotsu_ramen.id) }
        users.sample(4).each { |user| user.favorites.create(recipe_id: sio_ramen.id) }
        users.sample(6).each { |user| user.favorites.create(recipe_id: miso_ramen.id) }
      end

      it 'is in descending order of favorites count' do
        title_query = { title_has_every_term: 'ラーメン', s: { '0' => { name: 'favorites_count', dir: 'desc' } } }
        recipe_title_results = Recipe.ransack(title_query).result
        expected_results = [miso_ramen.id, sio_ramen.id, shoyu_ramen.id]
        expect(recipe_title_results.map(&:id)).to eq expected_results
      end
    end
  end

  describe 'search body' do
    let(:alice) { create(:user) }
    let(:miso_ramen) { create(:recipe, body: '味噌ラーメンの作り方です。', updated_at: 2.hours.ago, user: alice) }
    let(:shoyu_ramen) { create(:recipe, body: 'しょうゆラーメンの作り方です。', updated_at: 4.weeks.ago, user: alice) }
    let(:sio_ramen) { create(:recipe, body: '塩ラーメンの作り方です。', updated_at: 3.days.ago, user: alice) }
    let(:tonkotsu_ramen) { create(:recipe, body: '豚骨らーめんの作り方です。', updated_at: 2.days.ago, user: alice) }

    it 'is in descending order of updated_at' do
      body_query = { body_has_every_term: 'ラーメン', s: { '0' => { name: 'updated_at', dir: 'desc' } } }
      recipe_body_results = Recipe.ransack(body_query).result
      expected_results = [miso_ramen.id, sio_ramen.id, shoyu_ramen.id]
      expect(recipe_body_results.map(&:id)).to eq expected_results
    end

    context 'when sort by comments count' do
      before do
        users = create_list(:user, 3)
        create(:comment, recipe: tonkotsu_ramen, user: users.sample)
        create_list(:comment, 2, recipe: sio_ramen, user: users.sample)
        create_list(:comment, 5, recipe: shoyu_ramen, user: users.sample)
        create_list(:comment, 6, recipe: miso_ramen, user: users.sample)
      end

      it 'is in descending order of comments count' do
        body_query = { body_has_every_term: 'ラーメン', s: { '0' => { name: 'comments_count', dir: 'desc' } } }
        recipe_body_results = Recipe.ransack(body_query).result
        expected_results = [miso_ramen.id, shoyu_ramen.id, sio_ramen.id]
        expect(recipe_body_results.map(&:id)).to eq expected_results
      end
    end

    context 'when sort by favorites count' do
      before do
        users = create_list(:user, 6)
        users.sample.favorites.create(recipe_id: tonkotsu_ramen.id)
        users.sample(3).each { |user| user.favorites.create(recipe_id: miso_ramen.id) }
        users.sample(4).each { |user| user.favorites.create(recipe_id: shoyu_ramen.id) }
        users.sample(6).each { |user| user.favorites.create(recipe_id: sio_ramen.id) }
      end

      it 'is in descending order of favorites count' do
        body_query = { body_has_every_term: 'ラーメン', s: { '0' => { name: 'favorites_count', dir: 'desc' } } }
        recipe_body_results = Recipe.ransack(body_query).result
        expected_results = [sio_ramen.id, shoyu_ramen.id, miso_ramen.id]
        expect(recipe_body_results.map(&:id)).to eq expected_results
      end
    end
  end

  describe 'search nickname' do
    let(:alice) { create(:user, nickname: 'ユーザー1') }
    let(:bob) { create(:user, nickname: 'ユーザー2') }
    let(:carol) { create(:user, nickname: 'ユーザー3') }
    let(:dave) { create(:user, nickname: 'ユーザー4') }
    let(:ellen) { create(:user, nickname: 'user5') }

    context 'when sort by followers count' do
      before do
        alice.relationships.create(follow_id: carol.id)
        [alice, carol].each { |user| user.relationships.create(follow_id: ellen.id) }
        [alice, carol, ellen].each { |user| user.relationships.create(follow_id: bob.id) }
        [alice, bob, carol, ellen].each { |user| user.relationships.create(follow_id: dave.id) }
      end

      it 'is in descending order of followers count' do
        nickname_query = { nickname_has_every_term: 'ユーザー', s: { '0' => { name: 'followers_count', dir: 'desc' } } }
        user_nickname_results = User.ransack(nickname_query).result
        expected_results = [dave.id, bob.id, carol.id, alice.id]
        expect(user_nickname_results.map(&:id)).to eq expected_results
      end
    end

    context 'when sort by recipes count' do
      before do
        create(:recipe, user: dave)
        create_list(:recipe, 2, user: bob)
        create_list(:recipe, 4, user: alice)
        create_list(:recipe, 5, user: ellen)
      end

      it 'is in descending order of recipes count' do
        nickname_query = { nickname_has_every_term: 'ユーザー', s: { '0' => { name: 'recipes_count', dir: 'desc' } } }
        user_nickname_results = User.ransack(nickname_query).result
        expected_results = [alice.id, bob.id, dave.id, carol.id]
        expect(user_nickname_results.map(&:id)).to eq expected_results
      end
    end
  end

  describe 'search profile' do
    let(:alice) { create(:user, profile: 'こんにちは') }
    let(:bob) { create(:user, profile: 'Hi!') }
    let(:carol) { create(:user, profile: 'こんにちは') }
    let(:dave) { create(:user, profile: 'こんにちは') }
    let(:ellen) { create(:user, profile: 'こんにちは') }

    context 'when sort by followers count' do
      before do
        [bob, dave].each { |user| user.relationships.create(follow_id: ellen.id) }
        [bob, dave, ellen].each { |user| user.relationships.create(follow_id: alice.id) }
        [alice, bob, dave, ellen].each { |user| user.relationships.create(follow_id: carol.id) }
      end

      it 'is in descending order of followers count' do
        profile_query = { profile_has_every_term: 'こんにちは', s: { '0' => { name: 'followers_count', dir: 'desc' } } }
        user_profile_results = User.ransack(profile_query).result
        expected_results = [carol.id, alice.id, ellen.id, dave.id]
        expect(user_profile_results.map(&:id)).to eq expected_results
      end
    end

    context 'when sort by recipes count' do
      before do
        create(:recipe, user: carol)
        create_list(:recipe, 2, user: dave)
        create_list(:recipe, 4, user: ellen)
      end

      it 'is in descending order of recipes count' do
        profile_query = { profile_has_every_term: 'こんにちは', s: { '0' => { name: 'recipes_count', dir: 'desc' } } }
        user_profile_results = User.ransack(profile_query).result
        expected_results = [ellen.id, dave.id, carol.id, alice.id]
        expect(user_profile_results.map(&:id)).to eq expected_results
      end
    end
  end

  describe 'search tag' do
    let(:miso_ramen) { Tag.find_or_create_by(name: '味噌ラーメン') }
    let(:shoyu_ramen) { Tag.find_or_create_by(name: 'しょうゆラーメン') }
    let(:sio_ramen) { Tag.find_or_create_by(name: '塩ラーメン') }
    let(:tonkotsu_ramen) { Tag.find_or_create_by(name: '豚骨ラーメン') }

    before do
      user = create(:user)
      create(:recipe, user: user, tag_list: '味噌ラーメン, しょうゆラーメン, 塩ラーメン, 豚骨ラーメン')
      create(:recipe, user: user, tag_list: '味噌ラーメン, しょうゆラーメン, 塩ラーメン')
      create(:recipe, user: user, tag_list: '味噌ラーメン, しょうゆラーメン')
      create(:recipe, user: user, tag_list: '味噌ラーメン')
      Tag.find_or_create_by(name: '台湾らーめん')
    end

    it 'is in descending order of taggings_count' do
      name_query = {
        name_has_every_term: 'ラーメン', taggings_count_gteq: '1',
        s: { '0' => { name: 'taggings_count', dir: 'desc' } }
      }
      tag_name_results = Tag.ransack(name_query).result
      expected_results = [miso_ramen.id, shoyu_ramen.id, sio_ramen.id, tonkotsu_ramen.id]
      expect(tag_name_results.map(&:id)).to eq expected_results
    end
  end
end
