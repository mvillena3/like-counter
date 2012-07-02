module ApplicationHelper
  def page_title(title)
    title.empty? ? "WorthReading" : "WorthReading | #{title}"
  end
end
