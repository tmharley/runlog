# frozen_string_literal: true

module ShoesHelper
  def shoe_size_clean(size)
    half = '&frac12;'
    "#{size.floor}#{half if Rational(size).denominator == 2}".html_safe
  end

  def colors_for_display(shoe_color)
    style = "background: ##{shoe_color}"
    style += '; color: black' if Color::RGB.by_hex(shoe_color).brightness > 0.75
    style
  end

  def model_with_mileage(shoe)
    "#{shoe.model} (#{shoe.mileage.round(2)} mi)"
  end
end
