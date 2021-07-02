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
end
