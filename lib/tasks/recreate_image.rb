User.find_each do |user|
  begin
    p user.id
    user.user_image.recreate_versions! if user.user_image.present?
  rescue
    p "#{user.id} recreate failed."
  end
end

Recipe.find_each do |recipe|
  begin
    p recipe.id
    recipe.recipe_image.recreate_versions! if recipe.recipe_image.present?
  rescue
    p "#{recipe.id} recreate failed."
  end
end
