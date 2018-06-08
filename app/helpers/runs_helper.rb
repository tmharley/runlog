module RunsHelper

  def temp_class(temp)
    return nil if temp.nil?
    "temp#{temp / 10 * 10}"
  end

  def build_page_title(params)
    page_title_class = params[:type].pluralize rescue 'runs'
    if params[:year]
      "#{page_title_class.capitalize} in #{params[:year]}"
    else
      "All #{page_title_class}"
    end
  end

  def star_output(rating)
    return '' if rating.nil?
    star = build_icon('star')
    half = build_icon('star-half')
    case
    when rating < 45
      title = 'awful'
      content = half
    when rating < 65
      title = 'poor'
      content = star
    when rating < 80
      title = 'okay'
      content = star + half
    when rating < 90
      title = 'decent'
      content = star * 2
    when rating < 100
      title = 'average'
      content = star * 2 + half
    when rating < 110
      title = 'solid'
      content = star * 3
    when rating < 120
      title = 'good'
      content = star * 3 + half
    when rating < 135
      title = 'great'
      content = star * 4
    when rating < 155
      title = 'excellent'
      content = star * 4 + half
    else
      title = 'awesome'
      content = star * 5
    end
    "<span title=#{title} data-toggle=tooltip>#{content}</span>".html_safe
  end

  def local_time_string(time)
    time_as_local(time).strftime('%l:%M %p')
  end

  def local_date_time_string(time)
    time_as_local(time).strftime('%a %-m/%-d/%y %-l:%M %p')
  end
end
