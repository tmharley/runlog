module ApplicationHelper

  def full_title(page_title)
    base_title = "Run Log"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def build_glyphicon(name)
    "<span class='glyphicon glyphicon-#{name}'></span>".html_safe
  end
end
