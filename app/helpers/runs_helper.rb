module RunsHelper

  def temp_class(temp)
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
    star = build_glyphicon('star')
    half = '&frac12;'.html_safe
    if rating < 45
      output = "<span title='awful'>#{half}</span>"
    elsif rating < 65
      output = "<span title='poor'>#{star}</span>"
    elsif rating < 80
      output = "<span title='okay'>#{star + half}</span>"
    elsif rating < 90
      output = "<span title='decent'>#{star*2}</span>"
    elsif rating < 100
      output = "<span title='average'>#{star*2 + half}</span>"
    elsif rating < 110
      output = "<span title='solid'>#{star*3}</span>"
    elsif rating < 120
      output = "<span title='good'>#{star*3 + half}</span>"
    elsif rating < 135
      output = "<span title='great'>#{star*4}</span>"
    elsif rating < 155
      output = "<span title='excellent'>#{star*4 + half}</span>"
    else
      output = "<span title='awesome'>#{star*5}</span>"
    end
    output.html_safe
  end
end
