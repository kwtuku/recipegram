module ApplicationHelper
  def recipes_show?
    if controller.controller_name == "recipes" && controller.action_name == "show"
      true
    end
  end
end
