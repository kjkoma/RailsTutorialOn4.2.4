module ApplicationHelper

  # This Helper is returnd Full Title
  def full_title(page_title)
    base_title = "StaticRailsApp"
    if page_title.empty?
      base_title
    else
  	  "#{base_title} | #{page_title}"
  	end
  end
end
