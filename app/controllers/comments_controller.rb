class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.recipe_id = params[:recipe_id]
    if @comment.save
      flash[:notice] = "成功！"
      redirect_to("/recipes/#{params[:recipe_id]}")
    else
      @recipe = Recipe.find(params[:recipe_id])
      flash.now[:alert] = "失敗！"
      render "recipes/show"
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
