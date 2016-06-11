json.array!(@words) do |word|
  json.extract! word, :id, :en, :pl, :user_id
  json.url word_url(word, format: :json)
end
