class Run < ActiveRecord::Base
  belongs_to :shoe
  belongs_to :weather_type

  validates :start_time, presence: true
  validates :distance, numericality: {greater_than: 0}
  validates :duration, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true
  validates :temperature, numericality: {only_integer: true}, allow_nil: true
  validates :elev_gain, numericality: {only_integer: true, greater_than_or_equal_to: 0}, allow_nil: true

  REG_INTERCEPT = 716.1135
  REG_DISTANCE = 5.6473
  REG_TEMPERATURE = 0.4934
  REG_HILLS = 0.7546
  REG_TIME = -12.2513
  REG_RACE_ADJ = -53.9609

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

  def start_time_local_date_string
    local_time.strftime("%A, %B %e, %Y")
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

  def climb_rate_string
    elev_gain.nil? ? 'N/A' : "#{climb_rate.round(1)} ft/mi"
  end

  def days_from_start
    @@first_run_date ||= Run.order('start_time ASC').first.start_time.to_date
    start_time.to_date - @@first_run_date
  end

  def sip_plus
    return nil if sip.nil?
    stats = Run.sip_stats
    (sip - stats[:mean]) / stats[:stdev] * 50 + 100
  end

  def sip
    adjusted_pace.nil? ? nil : 3600 / adjusted_pace
  end

  def precip?
    weather_type && weather_type.is_precip?
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
    return nil unless duration? and elev_gain and temperature
    pace - (distance - Run.average_distance) * REG_DISTANCE - (temperature - Run.average_temperature) * REG_TEMPERATURE - (climb_rate - Run.average_hills) * REG_HILLS - days_from_start**0.4 * REG_TIME
  end
end
