module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Recipegram'
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def no_recipes_description(user)
    blank_or_nickname =
      user == current_user ? '' : "#{user.nickname}さんは"
    case controller.action_name
    when 'comments'
      "#{blank_or_nickname}まだレシピにコメントをしていません"
    when 'favorites'
      "#{blank_or_nickname}まだレシピにいいねをしていません"
    else
      "#{blank_or_nickname}まだレシピを投稿していません"
    end
  end

  def no_follows_description(user)
    blank_or_nickname =
      user == current_user ? '' : "#{user.nickname}さんは"
    if controller.action_name == 'followers'
      "#{blank_or_nickname}まだフォロワーがいません"
    else
      "#{blank_or_nickname}まだ誰もフォローしていません"
    end
  end

  def selected_sort_order
    case request.query_parameters[:sort]
    when 'comments_count'
      request.query_parameters[:order] == 'asc' ? 'コメントが少ない順' : 'コメントが多い順'
    when 'favorites_count'
      request.query_parameters[:order] == 'asc' ? 'いいねが少ない順' : 'いいねが多い順'
    when 'updated_at'
      request.query_parameters[:order] == 'asc' ? '更新日が古い順' : '更新日が新しい順'
    when 'followers_count'
      request.query_parameters[:order] == 'asc' ? 'フォロワーが少ない順' : 'フォロワーが多い順'
    when 'followings_count'
      request.query_parameters[:order] == 'asc' ? 'フォロー中が少ない順' : 'フォロー中が多い順'
    when 'recipes_count'
      request.query_parameters[:order] == 'asc' ? '投稿が少ない順' : '投稿が多い順'
    when 'taggings_count'
      request.query_parameters[:order] == 'asc' ? '投稿が少ない順' : '投稿が多い順'
    else
      '並び替え'
    end
  end

  def show_some_lines_depends_on(other_recipes)
    if other_recipes.blank?
      'is-12-lines'
    else
      'is-4-lines'
    end
  end

  def recommended_description(user)
    return unless user_signed_in?

    followers_you_follow = user.followers_you_follow(current_user)
    if followers_you_follow.size >= 2
      "#{followers_you_follow.sample.nickname.truncate(14)}さん、他#{followers_you_follow.size - 1}人がフォロー中"
    elsif followers_you_follow.size == 1
      "#{followers_you_follow.sample.nickname.truncate(20)}さんがフォロー中"
    else
      user.following?(current_user) ? 'あなたをフォローしています' : 'おすすめ'
    end
  end

  def feed_description(feed)
    return 'おすすめ' unless user_signed_in?

    'おすすめ' if feed.user != current_user && !current_user.following?(feed.user)
  end

  def sort_order?(sort, order)
    request.query_parameters[:sort] == sort && request.query_parameters[:order] == order
  end
end
