namespace :words_tasks do
  desc "TODO"
  task verify_last_word: :environment do

    @word = Word.where(verified: false).last 
    @word.verified = true
    @word.save
  end

end
