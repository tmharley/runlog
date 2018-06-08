module ApplicationHelper
  ICONS = {
    calendar: 'calendar',
    distance: 'ruler',
    duration: 'hour-glass',
    elevation: 'area-graph',
    notes: 'typing',
    pace: 'stopwatch',
    rain: 'drop',
    star: 'star',
    start_time: 'clock',
    weather: 'cloud'
  }

  def full_title(page_title)
    base_title = "Run Log"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def build_icon(name)
    image_tag "icons/#{ICONS[name]}.svg", class: 'icon'
  end

  def time_as_local(time)
    time.in_time_zone("Eastern Time (US & Canada)")
  end
end
