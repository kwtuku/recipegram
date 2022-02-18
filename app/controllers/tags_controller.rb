class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def index
    tags = Tag.where('name LIKE ?', "%#{Tag.sanitize_sql_like(params[:name])}%").limit(5).pluck(:name)
    render json: { message: 'Loaded tags', data: tags }, status: :ok
  end

  def show
    @tag = Tag.find_by(name: params[:name])
    raise ActiveRecord::RecordNotFound unless @tag

    @tagged_recipes = Recipe.tagged_with(@tag.name).order(id: :DESC).limit(40)
  end
end
