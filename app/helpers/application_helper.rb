module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Recipegram'
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  def follows_or_no_follow_description(follows, user)
    if follows.exists?
      render partial: 'users/user_list', collection: follows, as: 'user'
    else
      no_follow_description(user)
    end
  end

  def no_follow_description(user)
    if user == current_user && controller.action_name == 'followings'
      tag.p 'まだ誰もフォローしていません'
    elsif user != current_user && controller.action_name == 'followings'
      tag.p "#{user.username}さんはまだ誰もフォローしていません"
    elsif user == current_user && controller.action_name == 'followers'
      tag.p 'まだフォロワーがいません'
    else
      tag.p "#{user.username}さんはまだ誰もフォローしていません"
    end
  end

  def recipe_sort_condition
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
end
