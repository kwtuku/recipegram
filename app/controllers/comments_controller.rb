class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.recipe_id = params[:recipe_id]
    if @comment.save
      @comment.create_comment_notification!(current_user, @comment.id, @comment.recipe.id)
      redirect_to "/recipes/#{params[:recipe_id]}", notice: 'レシピにコメントしました。'
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
