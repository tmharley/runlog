module RunsHelper

  def temp_class(temp)
    return nil if temp.nil?

    "temp#{temp / 10 * 10}"
  end

  def build_page_title(params)
    page_title_class = params[:type].pluralize rescue 'runs'
    if params[:year]
      "#{page_title_class.capitalize} in #{params[:year]}"
    elsif params[:start_date]
      'Search results'
    else
      "All #{page_title_class}"
    end
  end

  def star_output(rating)
    return '' if rating.nil?

    star = build_icon('star')
    half = build_icon('star-half')
    if rating < 45
      title = 'awful'
      content = half
    elsif rating < 65
      title = 'poor'
      content = star
    elsif rating < 80
      title = 'okay'
      content = star + half
    elsif rating < 90
      title = 'decent'
      content = star * 2
    elsif rating < 100
      title = 'average'
      content = star * 2 + half
    elsif rating < 110
      title = 'solid'
      content = star * 3
    elsif rating < 120
      title = 'good'
      content = star * 3 + half
    elsif rating < 135
      title = 'great'
      content = star * 4
    elsif rating < 155
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
