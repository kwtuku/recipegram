module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Recipegram'
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def recipes_or_no_recipes_description(recipes, user)
    if recipes.exists?
      render recipes
    else
      no_recipes_description(user)
    end
  end

  def no_recipes_description(user)
    description = if user == current_user && controller.action_name == 'show'
                    'まだレシピを投稿していません'
                  elsif user == current_user && controller.action_name == 'comments'
                    'まだレシピにコメントをしていません'
                  elsif user == current_user && controller.action_name == 'favorites'
                    'まだレシピにいいねをしていません'
                  elsif user != current_user && controller.action_name == 'show'
                    "#{user.username}さんはまだレシピを投稿していません"
                  elsif user != current_user && controller.action_name == 'comments'
                    "#{user.username}さんはまだレシピにコメントをしていません"
                  else
                    "#{user.username}さんはまだレシピにいいねをしていません"
                  end
    tag.div tag.p(description, class: 'has-text-centered'), class: 'column'
  end

  def follows_or_no_follows_description(follows, user)
    if follows.exists?
      render partial: 'users/follow', collection: follows, as: 'user'
    else
      no_follows_description(user)
    end
  end

  def no_follows_description(user)
    if user == current_user && controller.action_name == 'followings'
      tag.p 'まだ誰もフォローしていません'
    elsif user == current_user && controller.action_name == 'followers'
      tag.p 'まだフォロワーがいません'
    elsif user != current_user && controller.action_name == 'followings'
      tag.p "#{user.username}さんはまだ誰もフォローしていません"
    else
      tag.p "#{user.username}さんはまだ誰もフォローしていません"
    end
  end

  def selected_recipe_sort_order
    if request.query_parameters[:sort] == 'updated_at' && request.query_parameters[:order] == 'asc'
      '更新日が古い順'
    elsif request.query_parameters[:sort] == 'updated_at' && request.query_parameters[:order] == 'desc'
      '更新日が新しい順'
    elsif request.query_parameters[:sort] == 'favorites_count' && request.query_parameters[:order] == 'asc'
      'いいねが少ない順'
    elsif request.query_parameters[:sort] == 'favorites_count' && request.query_parameters[:order] == 'desc'
      'いいねが多い順'
    elsif request.query_parameters[:sort] == 'comments_count' && request.query_parameters[:order] == 'asc'
      'コメントが少ない順'
    elsif request.query_parameters[:sort] == 'comments_count' && request.query_parameters[:order] == 'desc'
      'コメントが多い順'
    else
      'デフォルト'
    end
  end

  def selected_user_sort_order
    if request.query_parameters[:sort] == 'recipes_count' && request.query_parameters[:order] == 'asc'
      '投稿が少ない順'
    elsif request.query_parameters[:sort] == 'recipes_count' && request.query_parameters[:order] == 'desc'
      '投稿が多い順'
    elsif request.query_parameters[:sort] == 'followers_count' && request.query_parameters[:order] == 'asc'
      'フォロワーが少ない順'
    elsif request.query_parameters[:sort] == 'followers_count' && request.query_parameters[:order] == 'desc'
      'フォロワーが多い順'
    elsif request.query_parameters[:sort] == 'followings_count' && request.query_parameters[:order] == 'asc'
      'フォロー中が少ない順'
    elsif request.query_parameters[:sort] == 'followings_count' && request.query_parameters[:order] == 'desc'
      'フォロー中が多い順'
    else
      'デフォルト'
    end
  end

  def show_some_lines_depends_on(other_recipes)
    if other_recipes.blank?
      'is-14-lines'
    elsif other_recipes.size >= 4
      'is-3-lines'
    else
      'is-7-lines'
    end
  end
end
