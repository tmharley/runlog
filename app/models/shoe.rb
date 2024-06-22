class Shoe < ApplicationRecord
  has_many :runs

  scope :active, -> { where retired: false }

  validates :manufacturer, presence: true
  validates :model, presence: true
  validates :color_primary, presence: true
  validates :color_secondary, presence: true
  validates :size, numericality: true

  BRIGHTNESS_THRESHOLD = 0.2

  def mileage(as_of: Time.now)
    runs.where("start_time <= '#{as_of}'").inject(0) { |a, b| a + b.distance }
  end

  def last_run
    runs.max_by(&:start_time)
  end

  def last_used
    last_run.start_time rescue nil
  end

  def last_used_local_string
    last_used ? last_used.strftime('%a %-m/%-d/%y') : 'never'
  end

  def bright_color
    max = colors.max { |a, b| a.brightness <=> b.brightness }
    min = colors.min { |a, b| a.brightness <=> b.brightness }
    if max.brightness > min.brightness + BRIGHTNESS_THRESHOLD
      max
    else
      tert = Color::RGB.by_hex(color_tertiary)
      tert.brightness > max.brightness ? tert : max
    end
  end

  def dark_color
    max = colors.max { |a, b| a.brightness <=> b.brightness }
    min = colors.min { |a, b| a.brightness <=> b.brightness }
    if min.brightness < max.brightness - BRIGHTNESS_THRESHOLD
      min
    else
      tert = Color::RGB.by_hex(color_tertiary)
      tert.brightness < min.brightness ? tert : min
    end
  end

  private

  def colors
    [color_primary, color_secondary].collect { |c| Color::RGB.by_hex(c) }
  end
end
