class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.recipe_id = params[:recipe_id]
    if @comment.save
      redirect_to "/recipes/#{params[:recipe_id]}", notice: 'レシピにコメントしました。'
      Notification.create_comment_notification(@comment)
    else
      @recipe = Recipe.find(params[:recipe_id])
      @other_recipes = @recipe.others(3)
      @comments = @recipe.comments.eager_load(:user).order(:id)
      render 'recipes/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @recipe = @comment.recipe
    if @comment.user != current_user
      redirect_to recipe_url(@recipe), alert: '権限がありません。'
    else
      @comment.destroy
      redirect_to recipe_url(@recipe), notice: 'コメントを削除しました。'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
