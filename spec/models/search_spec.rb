require 'rails_helper'

RSpec.describe 'Search', type: :model do
  let!(:miso_ramen) { create :recipe, title: '味噌ラーメンの作り方', body: '味噌ラーメンの作り方です。', updated_at: 2.hours.ago }
  let!(:miso_soup) { create :recipe, title: '味噌汁', body: '味噌汁の作り方です。', updated_at: 6.years.ago }
  let!(:miso_katsudon) { create :recipe, title: '味噌カツ丼', body: '味噌カツ丼の作り方です。', updated_at: 4.weeks.ago }
  let!(:miso_udon) { create :recipe, title: '味噌煮込みうどん', body: '味噌煮込みうどんの作り方です。', updated_at: 3.days.ago }
  let!(:miso) { create :recipe, title: '味噌', body: 'みその作り方です。', updated_at: 5.months.ago }
  let!(:tonkotsu_ramen) { create :recipe, title: '豚骨ラーメン', body: '豚骨ラーメンの作り方です。' }

  let!(:alice) { create :user, username: 'ユーザー1', profile: 'プロフィールです。' }
  let!(:bob) { create :user, username: 'ユーザー2', profile: 'Hi!' }
  let!(:carol) { create :user, username: 'ユーザー3', profile: 'プロフィールです。' }
  let!(:dave) { create :user, username: 'ユーザー4', profile: 'プロフィールです。' }
  let!(:ellen) { create :user, username: 'ユーザー5', profile: 'Yey!' }
  let!(:frank) { create :user, username: 'frank', profile: 'プロフィールです。' }

  describe 'search title' do
    before do
      users = [alice, bob, carol, dave, ellen, frank]
      users.sample(1).each { |user| user.comments.create(recipe_id: miso_soup.id, body: 'コメントです。' ) }
      users.sample(2).each { |user| user.comments.create(recipe_id: miso_ramen.id, body: 'コメントです。' ) }
      users.sample(4).each { |user| user.comments.create(recipe_id: miso.id, body: 'コメントです。' ) }
      users.sample(5).each { |user| user.comments.create(recipe_id: miso_udon.id, body: 'コメントです。') }

      users.sample(1).each { |user| user.favorites.create(recipe_id: miso.id) }
      users.sample(3).each { |user| user.favorites.create(recipe_id: miso_udon.id) }
      users.sample(4).each { |user| user.favorites.create(recipe_id: miso_katsudon.id) }
      users.sample(6).each { |user| user.favorites.create(recipe_id: miso_ramen.id) }
    end

    it 'is in ascending order of comments count' do
      title_q = { title_has_every_term: '味噌', s: { '0' => { name: 'comments_count', dir: 'asc' } } }
      recipe_title_results = Recipe.ransack(title_q).result
      expect(recipe_title_results.map(&:id)).to eq [miso_katsudon.id, miso_soup.id, miso_ramen.id, miso.id, miso_udon.id]
    end

    it 'is in descending order of comments count' do
      title_q = { title_has_every_term: '味噌', s: { '0' => { name: 'comments_count', dir: 'desc' } } }
      recipe_title_results = Recipe.ransack(title_q).result
      expect(recipe_title_results.map(&:id)).to eq [miso_katsudon.id, miso_soup.id, miso_ramen.id, miso.id, miso_udon.id].reverse
    end

    it 'is in ascending order of favorites count' do
      title_q = { title_has_every_term: '味噌', s: { '0' => { name: 'favorites_count', dir: 'asc' } } }
      recipe_title_results = Recipe.ransack(title_q).result
      expect(recipe_title_results.map(&:id)).to eq [miso_soup.id, miso.id, miso_udon.id, miso_katsudon.id, miso_ramen.id]
    end

    it 'is in descending order of favorites count' do
      title_q = { title_has_every_term: '味噌', s: { '0' => { name: 'favorites_count', dir: 'desc' } } }
      recipe_title_results = Recipe.ransack(title_q).result
      expect(recipe_title_results.map(&:id)).to eq [miso_soup.id, miso.id, miso_udon.id, miso_katsudon.id, miso_ramen.id].reverse
    end

    it 'is in ascending order of updated_at' do
      title_q = { title_has_every_term: '味噌', s: { '0' => { name: 'updated_at', dir: 'asc' } } }
      recipe_title_results = Recipe.ransack(title_q).result
      expect(recipe_title_results.map(&:id)).to eq [miso_soup.id, miso.id, miso_katsudon.id, miso_udon.id, miso_ramen.id]
    end

    it 'is in descending order of updated_at' do
      title_q = { title_has_every_term: '味噌', s: { '0' => { name: 'updated_at', dir: 'desc' } } }
      recipe_title_results = Recipe.ransack(title_q).result
      expect(recipe_title_results.map(&:id)).to eq [miso_soup.id, miso.id, miso_katsudon.id, miso_udon.id, miso_ramen.id].reverse
    end
  end

  describe 'search body' do
    before do
      users = [alice, bob, carol, dave, ellen, frank]
      users.sample(1).each { |user| user.comments.create(recipe_id: miso_udon.id, body: 'コメントです。') }
      users.sample(2).each { |user| user.comments.create(recipe_id: miso_katsudon.id, body: 'コメントです。' ) }
      users.sample(5).each { |user| user.comments.create(recipe_id: miso_soup.id, body: 'コメントです。' ) }
      users.sample(6).each { |user| user.comments.create(recipe_id: miso_ramen.id, body: 'コメントです。' ) }

      users.sample(1).each { |user| user.favorites.create(recipe_id: miso_udon.id) }
      users.sample(2).each { |user| user.favorites.create(recipe_id: miso_ramen.id) }
      users.sample(4).each { |user| user.favorites.create(recipe_id: miso_soup.id) }
      users.sample(5).each { |user| user.favorites.create(recipe_id: miso_katsudon.id) }
    end

    it 'is in ascending order of comments count' do
      body_q = { body_has_every_term: '味噌', s: { '0' => { name: 'comments_count', dir: 'asc' } } }
      recipe_body_results = Recipe.ransack(body_q).result
      expect(recipe_body_results.map(&:id)).to eq [miso_udon.id, miso_katsudon.id, miso_soup.id, miso_ramen.id]
    end

    it 'is in descending order of comments count' do
      body_q = { body_has_every_term: '味噌', s: { '0' => { name: 'comments_count', dir: 'desc' } } }
      recipe_body_results = Recipe.ransack(body_q).result
      expect(recipe_body_results.map(&:id)).to eq [miso_udon.id, miso_katsudon.id, miso_soup.id, miso_ramen.id].reverse
    end

    it 'is in ascending order of favorites count' do
      body_q = { body_has_every_term: '味噌', s: { '0' => { name: 'favorites_count', dir: 'asc' } } }
      recipe_body_results = Recipe.ransack(body_q).result
      expect(recipe_body_results.map(&:id)).to eq [miso_udon.id, miso_ramen.id, miso_soup.id, miso_katsudon.id]
    end

    it 'is in descending order of favorites count' do
      body_q = { body_has_every_term: '味噌', s: { '0' => { name: 'favorites_count', dir: 'desc' } } }
      recipe_body_results = Recipe.ransack(body_q).result
      expect(recipe_body_results.map(&:id)).to eq [miso_udon.id, miso_ramen.id, miso_soup.id, miso_katsudon.id].reverse
    end

    it 'is in ascending order of updated_at' do
      body_q = { body_has_every_term: '味噌', s: { '0' => { name: 'updated_at', dir: 'asc' } } }
      recipe_body_results = Recipe.ransack(body_q).result
      expect(recipe_body_results.map(&:id)).to eq [miso_soup.id, miso_katsudon.id, miso_udon.id, miso_ramen.id]
    end

    it 'is in descending order of updated_at' do
      body_q = { body_has_every_term: '味噌', s: { '0' => { name: 'updated_at', dir: 'desc' } } }
      recipe_body_results = Recipe.ransack(body_q).result
      expect(recipe_body_results.map(&:id)).to eq [miso_soup.id, miso_katsudon.id, miso_udon.id, miso_ramen.id].reverse
    end
  end

  describe 'search username' do
    let!(:dave_recipes) { create_list(:recipe, 1, user: dave) }
    let!(:bob_recipes) { create_list(:recipe, 2, user: bob) }
    let!(:alice_recipes) { create_list(:recipe, 4, user: alice) }
    let!(:ellen_recipes) { create_list(:recipe, 5, user: ellen) }
    before do
      [alice].each { |user| user.relationships.create(follow_id: carol.id) }
      [alice, carol, frank].each { |user| user.relationships.create(follow_id: ellen.id) }
      [alice, carol, ellen, frank].each { |user| user.relationships.create(follow_id: bob.id) }
      [alice, bob, carol, ellen, frank].each { |user| user.relationships.create(follow_id: dave.id) }
    end

    it 'is in ascending order of followers count' do
      username_q = { username_has_every_term: 'ユーザー', s: { '0' => { name: 'followers_count', dir: 'asc' } } }
      user_username_results = User.ransack(username_q).result
      expect(user_username_results.map(&:id)).to eq [alice.id, carol.id, ellen.id, bob.id, dave.id]
    end

    it 'is in descending order of followers count' do
      username_q = { username_has_every_term: 'ユーザー', s: { '0' => { name: 'followers_count', dir: 'desc' } } }
      user_username_results = User.ransack(username_q).result
      expect(user_username_results.map(&:id)).to eq [alice.id, carol.id, ellen.id, bob.id, dave.id].reverse
    end

    it 'is in ascending order of followings count' do
      username_q = { username_has_every_term: 'ユーザー', s: { '0' => { name: 'followings_count', dir: 'asc' } } }
      user_username_results = User.ransack(username_q).result
      expect(user_username_results.map(&:id)).to eq [dave.id, bob.id, ellen.id, carol.id, alice.id]
    end

    it 'is in descending order of followings count' do
      username_q = { username_has_every_term: 'ユーザー', s: { '0' => { name: 'followings_count', dir: 'desc' } } }
      user_username_results = User.ransack(username_q).result
      expect(user_username_results.map(&:id)).to eq [dave.id, bob.id, ellen.id, carol.id, alice.id].reverse
    end

    it 'is in ascending order of recipes count' do
      username_q = { username_has_every_term: 'ユーザー', s: { '0' => { name: 'recipes_count', dir: 'asc' } } }
      user_username_results = User.ransack(username_q).result
      expect(user_username_results.map(&:id)).to eq [carol.id, dave.id, bob.id, alice.id, ellen.id]
    end

    it 'is in descending order of recipes count' do
      username_q = { username_has_every_term: 'ユーザー', s: { '0' => { name: 'recipes_count', dir: 'desc' } } }
      user_username_results = User.ransack(username_q).result
      expect(user_username_results.map(&:id)).to eq [carol.id, dave.id, bob.id, alice.id, ellen.id].reverse
    end
  end

  describe 'search profile' do
    let!(:carol_recipes) { create_list(:recipe, 1, user: carol) }
    let!(:dave_recipes) { create_list(:recipe, 2, user: dave) }
    let!(:frank_recipes) { create_list(:recipe, 4, user: frank) }
    before do
      [dave, alice].each { |user| user.relationships.create(follow_id: frank.id) }
      [bob, carol, dave].each { |user| user.relationships.create(follow_id: alice.id) }
      [alice, bob, dave, ellen].each { |user| user.relationships.create(follow_id: carol.id) }
    end

    it 'is in ascending order of followers count' do
      profile_q = { profile_has_every_term: 'プロフィール', s: { '0' => { name: 'followers_count', dir: 'asc' } } }
      user_profile_q = User.ransack(profile_q).result
      expect(user_profile_q.map(&:id)).to eq [dave.id, frank.id, alice.id, carol.id]
    end

    it 'is in descending order of followers count' do
      profile_q = { profile_has_every_term: 'プロフィール', s: { '0' => { name: 'followers_count', dir: 'desc' } } }
      user_profile_q = User.ransack(profile_q).result
      expect(user_profile_q.map(&:id)).to eq [dave.id, frank.id, alice.id, carol.id].reverse
    end

    it 'is in ascending order of followings count' do
      profile_q = { profile_has_every_term: 'プロフィール', s: { '0' => { name: 'followings_count', dir: 'asc' } } }
      user_profile_q = User.ransack(profile_q).result
      expect(user_profile_q.map(&:id)).to eq [frank.id, carol.id, alice.id, dave.id]
    end

    it 'is in descending order of followings count' do
      profile_q = { profile_has_every_term: 'プロフィール', s: { '0' => { name: 'followings_count', dir: 'desc' } } }
      user_profile_q = User.ransack(profile_q).result
      expect(user_profile_q.map(&:id)).to eq [frank.id, carol.id, alice.id, dave.id].reverse
    end

    it 'is in ascending order of recipes count' do
      profile_q = { profile_has_every_term: 'プロフィール', s: { '0' => { name: 'recipes_count', dir: 'asc' } } }
      user_profile_q = User.ransack(profile_q).result
      expect(user_profile_q.map(&:id)).to eq [alice.id, carol.id, dave.id, frank.id]
    end

    it 'is in descending order of recipes count' do
      profile_q = { profile_has_every_term: 'プロフィール', s: { '0' => { name: 'recipes_count', dir: 'desc' } } }
      user_profile_q = User.ransack(profile_q).result
      expect(user_profile_q.map(&:id)).to eq [alice.id, carol.id, dave.id, frank.id].reverse
    end
  end
end
