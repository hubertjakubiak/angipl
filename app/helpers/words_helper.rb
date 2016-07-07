module WordsHelper

  def good_answer
    @good_count = Stat.user_words(current_user.id).increment!(:good_count) if current_user
  end

  def bad_answer
    @bad_count = Stat.user_words(current_user.id).increment!(:bad_count) if current_user
  end

  def correctness(good_count, bad_count)
    number_to_percentage(good_count.to_f / (good_count + bad_count) * 100, { :precision => 1})
  end

end
