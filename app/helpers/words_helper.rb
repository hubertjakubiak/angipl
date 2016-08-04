module WordsHelper

  def good_answer
    @good_count = Stat.user_words(current_user.id).increment!(:good_count) if current_user
    Word.where(:id => @correct_answer_id).first.increment!(:good_count)
  end

  def bad_answer
    @bad_count = Stat.user_words(current_user.id).increment!(:bad_count) if current_user
    Word.where(:id => @correct_answer_id).first.increment!(:bad_count)
  end

  def correctness(good_count, bad_count)
    if good_count != 0 || bad_count != 0
      number_to_percentage(good_count.to_f / (good_count + bad_count) * 100, { :precision => 1})
    else
      return 'brak'
    end
  end

  def correctness_reverse(good_count, bad_count)
    number_to_percentage(100 - (good_count.to_f / (good_count + bad_count) * 100), { :precision => 1})
  end

  def my_words_size(user_id)
    Word.my_words(user_id).size
  end

end
