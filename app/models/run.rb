class Run < ApplicationRecord
  belongs_to :shoe, optional: true
  belongs_to :weather_type, optional: true

  validates :start_time, presence: true
  validates :distance, numericality: {greater_than: 0}
  validates :duration, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :temperature, numericality: {only_integer: true}, allow_nil: true
  validates :elev_gain, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

  REG_INTERCEPT = 348.6133
  REG_DISTANCE = 414.739
  REG_TEMPERATURE = 0.3417
  REG_HILLS = 0.6548
  REG_TIME = -24.3031
  REG_RACE_ADJ = -906.9538
  REG_RACE_DIST_ADJ = 775.4982

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

  def mileage_in_last_days(num_days)
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

    sim_dist = 1 - (distance - other.distance).abs / options[:dist_range]
    sim_hill = 1 - (climb_rate - other.climb_rate).abs / options[:hill_range]
    sim_temp = 1 - (temperature - other.temperature).abs / options[:temp_range]

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

  def start_time_local_time_string
    local_time.strftime("%l:%M %p")
  end

  def start_time_local_string
    local_time.strftime("%a %-m/%-d/%y %-l:%M %p")
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

  def sip_plus
    return nil if sip.nil?
    stats = Run.sip_stats
    result = (sip - stats[:mean]) / stats[:stdev] * 50 + 100
    result.nan? ? nil : result
  end

  def sip
    adjusted_pace.nil? ? nil : 3600 / adjusted_pace
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

  def training_ratio
    acute = mileage_in_last_days(7)
    chronic = mileage_in_last_days(28) / 4
    acute / chronic
  end

  private

  def self.sip_stats
    @@sip_stats ||= nil
    if @@sip_stats.nil?
      sip_runs = Run.where.not(elev_gain: nil, temperature: nil, duration: 0)
      stats = DescriptiveStatistics::Stats.new(sip_runs.map {|r| r.sip})
      @@sip_stats = {mean: stats.mean, stdev: stats.standard_deviation}
    end
    @@sip_stats
  end

  def self.average_distance
    @average_distance ||= (Run.pluck(:distance).reduce(:+) / Run.count)
  end

  def self.average_temperature
    if @average_temperature.nil?
      temps = Run.where.not(temperature: nil).pluck(:temperature)
      @average_temperature = temps.reduce(:+) / temps.count
    end
    @average_temperature
  end

  def self.average_hills
    if @average_hills.nil?
      hills = Run.where.not(elev_gain: nil).pluck(:distance, :elev_gain).map {|r| r[1] / r[0]}
      @average_hills = hills.reduce(:+) / hills.count
    end
    @average_hills
  end

  def time_string(seconds)
    if seconds < 3600
      Time.at(seconds).strftime('%-M:%S')
    else
      h = seconds / 3600
      "#{h}:" + Time.at(seconds).strftime('%M:%S')
    end
  end

  def adjusted_pace
    return nil unless duration? && elev_gain && temperature
    pace - (distance**0.06 - Run.average_distance**0.06) * REG_DISTANCE - (temperature - Run.average_temperature) * REG_TEMPERATURE - (climb_rate - Run.average_hills) * REG_HILLS - days_from_start**(1.0/3) * REG_TIME
  end
end
