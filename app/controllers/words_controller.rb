class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :authenticate_user!, except: [:index, :show, :game, :search, :check_word]
  before_action :check_user , only: [:edit]

  # GET /words
  # GET /words.json
  def index
    @words = Word.includes(:user).all
  end

  # GET /words/1
  # GET /words/1.json
  def show
    commontator_thread_show(@word)
  end

  def my_words
    @user = current_user
    @words = @user.words
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
    
  end

  # POST /words
  # POST /words.json
  def create
    @user = current_user
    @word = @user.words.build(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word, info: 'Słówka zostało prawidłowo zapisane.' }
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
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Słówka zostało usunięte' }
      format.json { head :no_content }
    end
  end

  def game
    rand = rand(1..3)
    ids = Word.pluck(:id).shuffle[0..rand]
    @words = Word.where(id: ids).order('random()')
    @first_word = @words.first

    #create stats of user if not exists earlier
    @create_stat = Stat.where(:user_id => current_user.id).first_or_create if current_user
    @all_good_count = Stat.sum(:good_count)
    @all_bad_count = Stat.sum(:bad_count)

    #get stats
    @stats = Stat.find_by_user_id(current_user.id) if current_user
    # check if there is enough words in database
    if Word.all.size < 5
      flash[:notice] = 'Brak słówek w bazie. Dodaj minimum 5 słówek'
      redirect_to new_word_path
    end

  end

  def check_word

    @en = params[:en]
    @pl = params[:pl]

    @correct_answer = Word.find_by_pl(@pl).en
    @correct_answer_id = Word.find_by_pl(@pl).id

    @result = Word.where(["en = ? and pl = ?", "#{@en}", "#{@pl}"]).size.to_s

    respond_to do |format|
      format.html
      format.js
    end
  end

  def search
    @words = Word.search(params[:search])
  end

  def upvote
    @word.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @word.downvote_by current_user
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:en, :pl, :user_id)
    end

    def check_user
      if @word.user != current_user
        flash[:error] = 'Tego słówka nie możesz edytować.'
        redirect_to root_path
      end

    end
end
