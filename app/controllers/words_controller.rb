class WordsController < ApplicationController

  expose(:words) { Word.includes(:user, :categories).sorted.paginate(:page => params[:page]).all }
  expose(:game_words) {Word.verified}
  expose(:my_words) { current_user.words.sorted.paginate(:page => params[:page]) }
  expose(:unverified_words) { Word.unverified.recent.paginate(:page => params[:page]) }
  expose(:verified_words) { Word.verified}
  expose(:word, attributes: :word_params)
  expose(:comment) { Comment.new }
  expose(:search_words) { Word.search(params[:search]).paginate(:page => params[:page])}
  expose(:category) { Category.find_by_name(params[:category]) }
  expose(:category_words) {category.words.where(:verified => true) if category } 
  expose(:categories) { Category.all.order("name ASC") }
  expose(:all_good_count) { Stat.sum(:good_count) }
  expose(:all_bad_count) { Stat.sum(:bad_count) }
  expose(:my_stats) { Stat.find_by_user_id(current_user.id) if current_user }

  MIN_WORDS_FOR_GAME = 5
  MIN_WORDS_FOR_CATEGORY = 5
  MIN_WORDS_FOR_MY_WORDS = 5
  MIN_DIFF_TO_VERIFY_WORD = 3

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

  def game

    unless enough_words?
      flash[:notice] = 'Brak słówek w bazie. Dodaj minimum 5 słówek'
      redirect_to words_path
    end

    if category_is_defined_and_exists?

      unless category_has_enough_words?
        respond_to do |format|
          format.html { redirect_to root_path, notice: 'Kategoria musi zawierać minimum 5 słówek.' }
        end
      end

      get_random_words(words: category_words)

    elsif params[:category] == "Moje słówka"

      unless user_has_enough_my_words?
        respond_to do |format|
          format.html { redirect_to root_path, notice: 'Musisz dodać minimum 5 swoich słówek' }
        end
      end

      get_random_words(words: my_words)

    elsif params[:category]
      respond_to do |format|
          format.html { redirect_to root_path, notice: 'Taka kategoria nie istnieje.' }
        end
    else

      get_random_words(words: game_words)

    end

    create_stat_for_user_if_not_exists

  end

  def check

    @en = params[:en]
    @pl = params[:pl]
    @time = params[:time]

    @correct_answer = Word.find_by_pl(@pl).en
    @correct_answer_id = Word.find_by_pl(@pl).id

    @result = Word.where(["en = ? and pl = ?", "#{@en}", "#{@pl}"]).size.to_s

    respond_to do |format|
      format.js
    end
  end

  def search
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
    Word.import(params[:file])
    flash[:notice] = "Dane zostały zaimportowane."
    redirect_to root_url
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

    def enough_words?
      verified_words.size >= MIN_WORDS_FOR_GAME
    end

    def category_has_enough_words?
      category_words.count >= MIN_WORDS_FOR_CATEGORY ? true : false
    end

    def user_has_enough_my_words?
      my_words.count >= MIN_WORDS_FOR_MY_WORDS ? true : false
    end

    def category_is_defined_and_exists?
      params[:category] && category_words
    end

    def get_random_words(max_answers: 3, words:)
      rand = rand(1..max_answers)
      ids = words.pluck(:id).shuffle[0..rand]
      @words = words.where(id: ids).order('random()')
      #@words = words.where(id: ids)
      @first_word = @words.first
      @words = @words.map { |word| word.en }.uniq
    end

    def create_stat_for_user_if_not_exists
      Stat.where(:user_id => current_user.id).first_or_create if current_user
    end
end
