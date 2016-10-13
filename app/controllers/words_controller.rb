class WordsController < ApplicationController

  expose(:word, attributes: :word_params)
  expose(:words) { Word.includes(:user, :categories).sorted.paginate(:page => params[:page]).all }
  expose(:words_all) { Word.all }
  expose(:my_words) { current_user.words.sorted.paginate(:page => params[:page]) }
  expose(:unverified_words) { Word.unverified.recent.paginate(:page => params[:page]) }
  expose(:comment) { Comment.new }
  expose(:search_words) { SearchWord.scope(params[:search]).paginate(:page => params[:page])}

  MIN_DIFF_TO_VERIFY_WORD = 3

  def index
    respond_to do |format|
      format.html
      format.csv { send_data words_all.to_csv }
    end
  end

  def my
    authorize! :my_words, word, :message => "Musisz się zalogować, aby mieć swoje słówka."
  end

  # GET /words/new
  def new
    authorize! :create, word, :message => "Musisz się zalogować, aby dodać nowe słówko."
  end

  def edit
    authorize! :edit, word, :message => "Nie możesz edytować tego słówka."
  end

  def create
    authorize! :create, word, :message => "Musisz się zalogować, aby dodać nowe słówko."
    word.user = current_user
    if word.save
      redirect_to new_word_path
      flash[:notice] = 'Słówko zostało prawidłowo zapisane. Dodaj następne!'
    else
      render :new
    end
  end

  def update
    if word.update(word_params)
      redirect_to word_path(word), notice: 'Słówko został prawidłowo edytowane.'
    else
      render :edit
    end
  end
  
  def destroy
    authorize! :delete, word, :message => "Nie możesz usunąć tego słówka."
    word.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Słówka zostało usunięte' }
      format.json { head :no_content }
    end
  end

  def upvote
    if current_user
      word.upvote_by current_user

      #get votes
      @good_votes = word.get_upvotes.size
      @bad_votes = word.get_downvotes.size

      if (@good_votes - @bad_votes) >= MIN_DIFF_TO_VERIFY_WORD
        word.update(verified: true)
      end

      if current_user.admin?
        word.update(verified: true)
      end
      
      respond_to do |format|
        format.js
      end
    else
      must_login_to_vote
    end
  end

  def downvote
    if current_user
      word.downvote_by current_user

      @good_votes = word.get_upvotes.size
      @bad_votes = word.get_downvotes.size

      if current_user.admin?
        word.update(verified: false)
      end
      
      respond_to do |format|
        format.js 
      end
    else
      must_login_to_vote
    end

  end

  def import
    if params[:upload]
      Word.delay.import(params[:upload][:file])
      flash[:notice] = "Dane są w tej chwili importowane."
      redirect_to root_url
    else
      flash[:alert] = "Nie wgrałeś żadnego pliku."
      redirect_to :back
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:en, :pl, :user_id, :level, :category_ids => [])
    end

    def must_login_to_vote
      respond_to do |format|
        flash[:error] = 'Musisz się zalogować, aby oceniać tłumaczenia.'
        format.js {render :js => "window.location.reload();"}
      end
    end
end
