class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def index
    tags = ActsAsTaggableOn::Tag.where('name LIKE ?', "%#{params[:name]}%").pluck(:name).first(5)
    render json: { status: 'SUCCESS', message: 'Loaded tags', data: tags }
  end

  def show
    @tag = ActsAsTaggableOn::Tag.find_by(name: params[:name])
    raise ActiveRecord::RecordNotFound unless @tag

    @tagged_recipes = Recipe.tagged_with(@tag.name).eager_load(:comments, :favorites).order(id: :DESC).first(40)
  end
end
