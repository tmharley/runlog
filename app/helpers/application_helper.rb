module ApplicationHelper
  def full_title(page_title)
    base_title = "Run Log"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def build_icon(name, solid = true)
    base_type = solid ? 'fa' : 'far'
    "<i class='#{base_type} fa-#{name}'></i>".html_safe
  end

  def time_as_local(time)
    time.in_time_zone("Eastern Time (US & Canada)")
  end

  def local_date_string(time)
    time_as_local(time).strftime('%a %-m/%-d/%y')
  end
end
