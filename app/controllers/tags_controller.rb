class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def index
    tags = Tag.where('name LIKE ?', "%#{Tag.sanitize_sql_like(params[:name])}%").limit(5).pluck(:name)
    render json: { message: 'Loaded tags', data: tags }, status: :ok
  end

  def show
    @tag = Tag.find_by!(name: params[:name])
    @tagged_recipes = Recipe.tagged_with(@tag.name).order(id: :desc).page(params[:page]).without_count
  end
end
