class RecipePolicy < ApplicationPolicy
  def update?
    record.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    record.user_id == user.id
  end
end
