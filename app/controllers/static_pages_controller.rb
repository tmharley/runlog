class StaticPagesController < ApplicationController
  def home; end

  def training
    runs_by_day = (0...28).collect do |days_ago|
      Run.on_day(Date.today - days_ago.days)
    end

    @days = []
    runs_by_day.each_with_index do |runs, idx|
      last_week_miles = Run.last_days_from(7, Date.today - idx.days).pluck(:distance)
      l7d = last_week_miles.sum
      l4w = Run.last_days_from(28, Date.today - idx.days).pluck(:distance).sum / 4.0
      @days << {
        date: Date.today - idx.days,
        miles: runs.map(&:distance).sum,
        last_seven_days: l7d,
        last_four_weeks: l4w,
        atc: l7d / l4w,
        long_to_total: last_week_miles.max / l7d,
        intensity: runs.map(&:intensity).sum
      }
    end
  end
end
