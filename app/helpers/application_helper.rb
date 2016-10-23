module ApplicationHelper

  def title(page_title)
    content_for :title, page_title.to_s + " - Angi.pl"
  end

  def active?(path)
    'active' if current_page?(path)
  end
  

end
