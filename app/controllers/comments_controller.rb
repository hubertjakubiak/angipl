class CommentsController < ApplicationController
  expose(:word)
  expose(:comment) { word.comments.build(comment_params) }
  def create
    comment.user = current_user if current_user
    authorize! :create, comment, :message => "Musisz się zalogować, aby dodać komentarz."

    if comment.save
      redirect_to word_path(word)
    else
      render 'words/show'
    end
  end

  private

  def comment_params
      params.require(:comment).permit(:content)
    end
end
