class Shoe < ApplicationRecord
  attr_accessible :manufacturer, :model, :color_primary, :color_secondary, :color_tertiary, :size
  has_many :runs

  validates :manufacturer, presence: true
  validates :model, presence: true
  validates :color_primary, presence: true
  validates :color_secondary, presence: true
  validates :size, numericality: true

  BRIGHTNESS_THRESHOLD = 0.2

  def mileage
    runs.inject(0) { |a,b| a = a + b.distance }
  end

  def last_run
    runs.sort_by {|r| r.start_time}.last
  end

  def last_used
    last_run.start_time rescue nil
  end

  def last_used_local_time
    last_used.in_time_zone("Eastern Time (US & Canada)")
  end

  def last_used_local_string
    last_used ? last_used_local_time.strftime("%a %-m/%-d/%y") : 'never'
  end

  def bright_color
    max = colors.max {|a, b| a.brightness <=> b.brightness}
    min = colors.min {|a, b| a.brightness <=> b.brightness}
    if max.brightness > min.brightness + BRIGHTNESS_THRESHOLD
      max
    else
      tert = Color::RGB.by_hex(color_tertiary)
      tert.brightness > max.brightness ? tert : max
    end
  end

  def dark_color
    max = colors.max {|a, b| a.brightness <=> b.brightness}
    min = colors.min {|a, b| a.brightness <=> b.brightness}
    if min.brightness < max.brightness - BRIGHTNESS_THRESHOLD
      min
    else
      tert = Color::RGB.by_hex(color_tertiary)
      tert.brightness < min.brightness ? tert : min
    end
  end

  private
  def colors
    [color_primary, color_secondary].collect {|c| Color::RGB.by_hex(c)}
  end
end
