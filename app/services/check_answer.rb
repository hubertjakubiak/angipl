class CheckAnswer
  def initialize(en:, pl:)
    @en = en
    @pl = pl
  end

  def call
    check_translation
  end

  private

  def check_translation
    Word.where("lower(en) = ? and lower(pl) = ?", "#{en.downcase}", "#{pl.downcase}").count.to_s
  end

  attr_reader :en, :pl
end
