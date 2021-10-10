class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    @tag = ActsAsTaggableOn::Tag.find_by(name: params[:name])
    @tagged_recipes = Recipe.tagged_with(@tag.name).eager_load(:favorites, :comments)
  end
end
