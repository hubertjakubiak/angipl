module WordsHelper

  def good_answer
    Stat.user_words(current_user.id).increment!(:good_count) if current_user
  end

  def bad_answer
    Stat.user_words(current_user.id).increment!(:bad_count) if current_user
  end

end
