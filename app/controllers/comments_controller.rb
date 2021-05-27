class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.recipe_id = params[:recipe_id]
    if @comment.save
      @comment.create_comment_notification!(current_user, @comment.id, @comment.recipe.id)
      redirect_to "/recipes/#{params[:recipe_id]}", notice: '投稿に成功しました。'
    else
      @recipe = Recipe.find(params[:recipe_id])
      render "recipes/show"
    end
  end

  def destroy
    @comment = Comment.find(params[:recipe_id])
    @recipe = Recipe.find(params[:id])
    @comment.destroy
    redirect_to recipe_path(@recipe)
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
