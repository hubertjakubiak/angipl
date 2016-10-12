class SearchWord

  def self.search(search)
      Word.where("lower(words.en) LIKE '#{search.downcase}' OR lower(words.pl)  = '#{search.downcase}' ")
      #self.where("words.en LIKE ? OR words.pl LIKE ?" , "%#{search.downcase}%", "%#{search.downcase}%")
  end
end