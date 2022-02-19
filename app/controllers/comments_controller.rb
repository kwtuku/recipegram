class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.recipe_id = params[:recipe_id]
    if @comment.save
      redirect_to recipe_url(@comment.recipe), notice: 'レシピにコメントしました。'
      Notification.create_comment_notification(@comment)
    else
      @recipe = Recipe.find(params[:recipe_id])
      @other_recipes = @recipe.others(3)
      @comments = @recipe.comments.preload(:user).order(:id)
      render 'recipes/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    recipe = @comment.recipe
    authorize @comment
    @comment.destroy
    redirect_to recipe_url(recipe), notice: 'コメントを削除しました。'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
