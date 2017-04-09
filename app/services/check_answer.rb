class CheckAnswer
  def initialize(en:, pl:)
    @en = en
    @pl = pl
  end

  def call
    get_result
  end

  private

  def get_result
    Word.where(["lower(en) = ? and lower(pl) = ?", "#{en.downcase}", "#{pl.downcase}"]).count.to_s
  end

  attr_reader :en, :pl
end
