class GamesController < ApplicationController
  expose(:verified_words) { Word.verified }
  expose(:categories) { Category.all.order("name ASC") }
  expose(:category) { Category.find_by_name(params[:category]) }
  expose(:category_words) { category.words.where(verified: true) if category }
  expose(:my_words) { current_user.words }
  expose(:all_good_count) { Stat.sum(:good_count) }
  expose(:all_bad_count) { Stat.sum(:bad_count) }
  expose(:my_stats) { Stat.find_by_user_id(current_user.id) if current_user }

  MIN_WORDS_FOR_GAME = 5
  MIN_WORDS_FOR_CATEGORY = 5
  MIN_WORDS_FOR_MY_WORDS = 5

  def index
    return not_enough_words if not_enough_words?
    return category_needs_more_words if category_is_defined_and_exists? && category_has_not_enough_words?
    return not_enough_my_words if my_words? && not_enough_my_words?

    if category_is_defined_and_exists?
      get_random_words(words: category_words)
    elsif my_words?
      get_random_words(words: my_words)
    elsif category?
      category_does_not_exist
    else
      get_random_words(words: verified_words)
    end
  end

  def check
    get_answer

    self.time = params[:time]

    @correct_answer = Word.find_by_pl(pl).en
    @correct_answer_id = Word.find_by_pl(pl).id

    @result = CheckAnswer.new(en: en, pl: pl).call

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

    attr_accessor :en, :pl, :time

    def not_enough_words
      redirect_to words_path, notice: I18n.t("messages.not_enough_words")
    end

    def not_enough_my_words
      redirect_to root_path, notice: I18n.t("messages.my_words_not_enough")
    end

    def category_does_not_exist
      redirect_to root_path, notice: I18n.t("messages.category_does_not_exist")
    end

    def my_words?
      params[:category] == "Moje słówka"
    end

    def category?
      params[:category].present?
    end

    def category_needs_more_words
      redirect_to root_path, notice: I18n.t("messages.category_needs_more_words")
    end

    def get_answer
      if user_is_typing?
        self.en = params[:word][:en]
        self.pl = params[:word][:pl]
      else
        self.en = params[:en]
        self.pl = params[:pl]
      end
    end

    def user_is_typing?
      params[:word].present?
    end

    def not_enough_words?
      verified_words.size < MIN_WORDS_FOR_GAME
    end

    def category_has_not_enough_words?
      category_words.count < MIN_WORDS_FOR_CATEGORY
    end

    def not_enough_my_words?
      my_words.count < MIN_WORDS_FOR_MY_WORDS
    end

    def category_is_defined_and_exists?
      params[:category] && category_words
    end

    def get_random_words(max_answers: 3, words:)
      rand = rand(1..max_answers)
      ids = words.pluck(:id).shuffle[0..rand]
      @words = words.where(id: ids).order("random()")
      @question_word = @words.first
      @words = @words.map { |word| word.en }.uniq
    end
end
