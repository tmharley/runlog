class Run < ApplicationRecord
  belongs_to :shoe, optional: true
  belongs_to :weather_type, optional: true

  scope :last_week, -> { where start_time: (Time.now - 1.week)..Time.now }
  scope :on_day, ->(day) { where start_time: day.beginning_of_day...day.end_of_day }
  scope :last_days_from, ->(days, time) { where start_time: (time - (days - 1).days).beginning_of_day...time.end_of_day }

  validates :start_time, presence: true
  validates :distance, numericality: { greater_than: 0 }
  validates :duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :temperature, numericality: { only_integer: true }, allow_nil: true
  validates :elev_gain, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :humidity, numericality: 0..100, allow_nil: true
  validates :intensity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  REG_INTERCEPT = -614.6221
  REG_DISTANCE = 1125.7969
  REG_TEMPERATURE = 2.0218
  REG_TIME = -19.6665
  REG_STDEV = 26.04043

  # temporary constants, want these to be configurable:
  MIN_HEART_RATE = 59
  MAX_HEART_RATE = 210

  def similar_runs(limit = 5)
    comparable_runs = Run.all.select(&:can_be_compared?) #- Array(self)
    dists = comparable_runs.map(&:distance)
    hills = comparable_runs.map(&:climb_rate)
    temps = comparable_runs.map(&:temperature)

    dist_range = dists.max - dists.min
    hill_range = hills.max - hills.min
    temp_range = (temps.max - temps.min) * 1.0

    runs = comparable_runs.reject { |r| r == self }
    runs.map! do |r|
      {
        run: r,
        similarity: similarity(r,
                               dist_range: dist_range,
                               hill_range: hill_range,
                               temp_range: temp_range)
      }
    end
    runs.sort! { |a, b| b[:similarity] <=> a[:similarity] }
    runs[0...limit]
  end

  def similarity(other, options = {})
    return 0 unless other.is_a? Run
    return 0 unless can_be_compared? && other.can_be_compared?

    sim_dist = options[:dist_range].zero? ? 1 : 1 - (distance - other.distance).abs / options[:dist_range]
    sim_hill = options[:hill_range].zero? ? 1 : 1 - (climb_rate - other.climb_rate).abs / options[:hill_range]
    sim_temp = options[:temp_range].zero? ? 1 : 1 - (temperature - other.temperature).abs / options[:temp_range]

    (sim_dist + sim_hill + sim_temp) / 3
  end

  def can_be_compared?
    distance? && elev_gain? && temperature?
  end

  def validate
    errors.add(:start_time, 'is invalid') if @invalid_start_time
  end

  def start_time_string=(start_time_str)
    self.start_time = Time.parse(start_time_str)
  rescue ArgumentError
    @invalid_start_time = true
  end

  def local_time
    start_time.in_time_zone('Eastern Time (US & Canada)')
  end

  def start_time_string
    time = id? ? local_time : Time.now
    time.strftime('%Y-%m-%d %H:%M')
  end

  def day_of_week
    local_time.strftime('%A')
  end

  def time_of_day
    case local_time.hour
    when 4..11
      "#{day_of_week} morning"
    when 12..16
      "#{day_of_week} afternoon"
    when 17..21
      "#{day_of_week} evening"
    else
      "#{day_of_week} overnight"
    end
  end

  def duration_string=(str)
    self.duration = str.split(':').inject(0) { |a, m| a * 60 + m.to_i }
  end

  def duration_string
    duration? ? time_string(duration) : ''
  end

  def pace
    duration / distance
  end

  def distance_record?
    prev_distance_record = Run.where('start_time < :time', { time: start_time }).maximum('distance')
    distance? && (!prev_distance_record || distance > prev_distance_record)
  end

  def pace_record?
    duration? && Run.where('start_time < :time', { time: start_time }).select do |r|
      r.distance >= distance && r.duration? && r.pace <= pace
    end.empty?
  end

  def pace_string
    duration? ? "#{time_string(pace)}/mi" : 'N/A'
  end

  def climb_rate
    elev_gain / distance
  end

  def days_from_start
    @@first_run_date ||= Run.order('start_time ASC').first.start_time.to_date
    start_time.to_date - @@first_run_date
  end

  def precip?
    weather_type&.is_precip?
  end

  def shoe_name
    [shoe.manufacturer, shoe.model].join(' ')
  end

  def race_performance
    100 + 50 * (expected_race_pace - pace) / REG_STDEV
  end

  def previous
    Run.where(['start_time < ?', start_time]).order(start_time: :desc).first
  end

  def next
    Run.where(['start_time > ?', start_time]).order(:start_time).first
  end

  def shoe_mileage
    shoe&.mileage(as_of: start_time)
  end

  def dewpoint
    temp_c = (temperature - 32) * 5.0 / 9
    hum_pct = humidity * 0.01
    257.14 * Math.log(hum_pct * Math.exp((18.678 - temp_c / 234.5) * (temp_c / (257.14 + temp_c)))) / (18.678 - Math.log(hum_pct * Math.exp((18.678 - temp_c / 234.5) * (temp_c / (257.14 + temp_c))))) * 9 / 5 + 32
  end

  private

  def time_string(seconds)
    if seconds < 3600
      Time.at(seconds).strftime('%-M:%S')
    else
      h = seconds / 3600
      "#{h}:" + Time.at(seconds).strftime('%M:%S')
    end
  end

  def expected_race_pace
    REG_INTERCEPT + (distance ** 0.06) * REG_DISTANCE + temperature * REG_TEMPERATURE + (days_from_start ** (1.0 / 3)) * REG_TIME
  end
end
