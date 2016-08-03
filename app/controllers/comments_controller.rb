class CommentsController < ApplicationController

  def create
    @word = Word.find(params[:word_id])
    @comment = @word.comments.build(comment_params)
    @comment.user_id = current_user.id if current_user

    if @comment.save
      redirect_to word_path(@word)
    else
      render 'words/show'
    end
  end

  def destroy
  end

  private

  def comment_params
      params.require(:comment).permit(:content)
    end
end
