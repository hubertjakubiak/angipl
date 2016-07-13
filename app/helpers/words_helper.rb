module WordsHelper

  def good_answer
    @good_count = Stat.user_words(current_user.id).increment!(:good_count) if current_user
    puts Word.where(:id => @correct_answer_id).first.increment!(:good_count)
  end

  def bad_answer
    @bad_count = Stat.user_words(current_user.id).increment!(:bad_count) if current_user
    puts Word.where(:id => @correct_answer_id).first.increment!(:bad_count)
  end

  def correctness(good_count, bad_count)
    number_to_percentage(good_count.to_f / (good_count + bad_count) * 100, { :precision => 1})
  end

  def correctness_reverse(good_count, bad_count)
    number_to_percentage(100 - (good_count.to_f / (good_count + bad_count) * 100), { :precision => 1})
  end

end
