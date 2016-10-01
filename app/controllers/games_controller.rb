class GamesController < ApplicationController

  expose(:verified_words) { Word.verified}
  expose(:categories) { Category.all.order("name ASC") }
  expose(:category) { Category.find_by_name(params[:category]) }
  expose(:category_words) {category.words.where(:verified => true) if category } 
  expose(:all_good_count) { Stat.sum(:good_count) }
  expose(:all_bad_count) { Stat.sum(:bad_count) }
  expose(:my_stats) { Stat.find_by_user_id(current_user.id) if current_user }

  MIN_WORDS_FOR_GAME = 5
  MIN_WORDS_FOR_CATEGORY = 5
  MIN_WORDS_FOR_MY_WORDS = 5

  def index

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

      get_random_words(words: verified_words)

    end

    create_stat_for_user_if_not_exists
    create_setting_for_user_if_not_exists

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

  private

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

    def create_setting_for_user_if_not_exists
      Setting.where(:user_id => current_user.id).first_or_create if current_user
    end
end
