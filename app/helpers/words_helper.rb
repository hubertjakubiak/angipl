module WordsHelper

  def good_answer(time)
    @good_count = Stat.user_words(current_user.id).increment!(:good_count) if current_user
    Word.where(:id => @correct_answer_id).first.increment!(:good_count)
    rand = rand(0..100)

    diff = (Time.now.to_i - time.to_i)

    if diff.between?(0, 100)
      case diff
      when 0
        diff = 1000
      when 1
        diff = 500
      when 2
        diff = 400
      when 3
        diff = 300
      when 4
        diff = 200
      when 5
        diff = 100
      when 6
        diff = 50
      when 7
        diff = 25
      when 8
        diff = 10
      when 9
        diff = 5
      else
        diff = 1
      end
    else 
      diff = 1
    end

    Stat.user_words(current_user.id).increment!(:points, by = diff) if current_user
  end

  def bad_answer
    @bad_count = Stat.user_words(current_user.id).increment!(:bad_count) if current_user
    Word.where(:id => @correct_answer_id).first.increment!(:bad_count)
    Stat.user_words(current_user.id).update_attribute(:points, 0) if current_user
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
