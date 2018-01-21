class Run < ApplicationRecord
  belongs_to :shoe, optional: true
  belongs_to :weather_type, optional: true

  validates :start_time, presence: true
  validates :distance, numericality: {greater_than: 0}
  validates :duration, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :temperature, numericality: {only_integer: true}, allow_nil: true
  validates :elev_gain, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

  REG_INTERCEPT = -614.6221
  REG_DISTANCE = 1125.7969
  REG_TEMPERATURE = 2.0218
  REG_TIME = -19.6665
  REG_STDEV = 26.04043

  def self.mileage_between(start_date, end_date)
    Run.where(start_time: start_date.beginning_of_day..end_date.end_of_day)
       .map(&:distance).sum
  end

  def self.safe_mileage(start_date = Time.now)
    last_week = Run.mileage_between(start_date - 6.days, start_date)
    last_4_weeks = Run.mileage_between(start_date - 27.days, start_date)
    if last_week > last_4_weeks * 3/8
      0
    else
      (3 * last_4_weeks - 8 * last_week) / 5
    end
  end

  def self.mileage_in_last_days(num_days, start_time = Time.now)
    Run.mileage_between(start_time - (num_days - 1).days, start_time)
  end

  def similar_runs(limit = 5)
    dists = Run.where.not(distance: nil).pluck(:distance)
    hills = Run.where.not(elev_gain: nil).map(&:climb_rate)
    temps = Run.where.not(temperature: nil).pluck(:temperature)

    dist_range = dists.max - dists.min
    hill_range = hills.max - hills.min
    temp_range = (temps.max - temps.min) * 1.0

    runs = Run.all.select {|r| r.can_be_compared? && r != self}
    runs.map! do |r|
      {
        run: r,
        similarity: similarity(r, {
          dist_range: dist_range,
          hill_range: hill_range,
          temp_range: temp_range
        })
      }
    end
    runs.sort! {|a, b| b[:similarity] <=> a[:similarity]}
    runs[0...limit]
  end

  def similarity(other, options={})
    return 0 unless other.is_a? Run
    unless can_be_compared? && other.can_be_compared?
      return 0
    end

    sim_dist = options[:dist_range] == 0 ? 1 : 1 - (distance - other.distance).abs / options[:dist_range]
    sim_hill = options[:hill_range] == 0 ? 1 : 1 - (climb_rate - other.climb_rate).abs / options[:hill_range]
    sim_temp = options[:temp_range] == 0 ? 1 : 1 - (temperature - other.temperature).abs / options[:temp_range]

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
    start_time.in_time_zone("Eastern Time (US & Canada)")
  end

  def start_time_string
    time = id? ? local_time : Time.now
    time.strftime("%Y-%m-%d %H:%M")
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
    self.duration = str.split(':').inject(0){|a, m| a = a * 60 + m.to_i}
  end

  def duration_string
    duration? ? time_string(duration) : ''
  end

  def pace
    duration / distance
  end

  def is_distance_record?
    prev_distance_record = Run.where(start_time: Time.new(2012)..start_time - 1).maximum("distance")
    distance? && (!prev_distance_record || distance > prev_distance_record)
  end

  def is_pace_record?
    duration? && Run.where(start_time: Time.new(2012)..start_time - 1).select { |r|
      r.distance >= distance && r.duration? && r.pace <= pace
    }.empty?
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
    weather_type && weather_type.is_precip?
  end

  def weather_string
    weather_type.name
  end

  def shoe_name
    [shoe.manufacturer, shoe.model].join(' ')
  end

  def race_performance
    100 + 50 * (expected_race_pace - pace) / REG_STDEV
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
    REG_INTERCEPT + (distance ** 0.06) * REG_DISTANCE + temperature * REG_TEMPERATURE + (days_from_start ** (1.0/3)) * REG_TIME
  end
end
