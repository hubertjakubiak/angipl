namespace :words do
  desc "Verifing last word"
  task verify_last_word: :environment do

    word = Word.where(verified: false).last 
    word.verified = true
    word.save

    puts 'Last word was verified.'
  end

end
