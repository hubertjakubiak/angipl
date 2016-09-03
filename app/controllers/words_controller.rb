class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  # GET /words
  # GET /words.json
  def index
    @words = Word.includes(:user, :categories).sorted.paginate(:page => params[:page]).all
  end

  # GET /words/1
  # GET /words/1.json
  def show
    
  end

  def my
    authorize! :my_words, @words, :message => "Musisz się zalogować, aby dodać swoje słówka.xxx"
    @user = current_user
    @words = @user.words.sorted.paginate(:page => params[:page])

  end

  def to_verify
    @words = Word.notverified.paginate(:page => params[:page])
  end

  # GET /words/new
  def new
    @word = Word.new
    authorize! :create, @word, :message => "Musisz się zalogować, aby dodać nowe słówko."
  end

  # GET /words/1/edit
  def edit
    authorize! :edit, @word, :message => "Nie możesz edytować tego słówka."
  end

  # POST /words
  # POST /words.json
  def create
    @user = current_user
    @word = @user.words.build(word_params)
    authorize! :create, @word, :message => "Musisz się zalogować, aby dodać nowe słówko.bbbb"

    respond_to do |format|
      if @word.save
        format.html { 
          redirect_to new_word_path
          flash[:notice] = 'Słówko zostało prawidłowo zapisane. Dodaj następne!'
        }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    authorize! :update, @word, :message => "Nie możesz edytować tego słówka."
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Słówko został prawidłowo edytowane.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    authorize! :delete, @word, :message => "Nie możesz usunąć tego słówka."
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Słówka zostało usunięte' }
      format.json { head :no_content }
    end
  end

  def game
    rand = rand(1..3)
    ids = Word.verified.pluck(:id).shuffle[0..rand]
    @words = Word.where(id: ids).order('random()')
    @first_word = @words.first

    #create stats of user if not exists earlier
    @create_stat = Stat.where(:user_id => current_user.id).first_or_create if current_user
    @all_good_count = Stat.sum(:good_count)
    @all_bad_count = Stat.sum(:bad_count)

    #get stats
    @stats = Stat.find_by_user_id(current_user.id) if current_user
    # check if there is enough words in database
    if Word.verified.size < 5
      flash[:notice] = 'Brak słówek w bazie. Dodaj minimum 5 słówek'
      redirect_to new_word_path
    end

  end

  def check

    @en = params[:en]
    @pl = params[:pl]

    @correct_answer = Word.find_by_pl(@pl).en
    @correct_answer_id = Word.find_by_pl(@pl).id

    @result = Word.where(["en = ? and pl = ?", "#{@en}", "#{@pl}"]).size.to_s

    respond_to do |format|
      format.js
    end
  end

  def search
    if params[:search]
      @words_count = Word.search(params[:search]).count
      @words = Word.search(params[:search]).paginate(:page => params[:page])
    end
  end

  def upvote
    if current_user
      @word.upvote_by current_user

      #get votes
      @good_votes = @word.get_upvotes.size
      @bad_votes = @word.get_downvotes.size

      if (@good_votes - @bad_votes) >=10
        Word.find(@word.id).update(verified: true)
      end

      if current_user.admin?
        Word.find(@word.id).update(verified: true)
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
      @word.downvote_by current_user

      @good_votes = @word.get_upvotes.size
      @bad_votes = @word.get_downvotes.size

      if current_user.admin?
        Word.find(@word.id).update(verified: false)
      end
      
      respond_to do |format|
        format.js 
      end
    else
      must_login_to_vote
    end

  end

  def import
    Word.import(params[:file])
    flash[:notice] = "Dane zostały zaimportowane."
    redirect_to root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

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
