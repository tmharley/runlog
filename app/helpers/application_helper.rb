module ApplicationHelper
  def full_title(page_title)
    base_title = 'Run Log'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}".html_safe
    end
  end

  def build_icon(name, title: nil)
    "<i class='fas fa-#{name}' title='#{title}'></i>".html_safe
  end

  def build_weather_icon(run)
    wt = run.weather_type
    build_icon(run.is_night ? wt.night_icon : wt.day_icon, title: wt.name)
  end

  def time_as_local(time)
    time.in_time_zone('Eastern Time (US & Canada)')
  end

  def local_date_string(time)
    time_as_local(time).strftime('%a %-m/%-d/%y')
  end
end
