class StaticPagesController < ApplicationController
  def home; end

  def training
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today - 4.weeks
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today

    runs_by_day = @end_date.downto(@start_date).collect { |day| Run.on_day(day) }

    @days = []
    runs_by_day.each_with_index do |runs, idx|
      last_week_miles = Run.last_days_from(7, @end_date - idx.days).pluck(:distance)
      last_week_intensity = Run.last_days_from(7, @end_date - idx.days).pluck(:intensity).compact
      l7d = last_week_miles.sum
      l4w = Run.last_days_from(28, @end_date - idx.days).pluck(:distance).sum / 4.0
      duration_minutes = runs.map(&:duration).sum / 60.0
      total_intensity = runs.map(&:intensity).compact.sum
      @days << {
        date: @end_date - idx.days,
        miles: runs.map(&:distance).sum,
        last_seven_days: l7d,
        last_four_weeks: l4w,
        atc: l7d / l4w,
        long_to_total: last_week_miles.max / l7d,
        intensity: total_intensity,
        intensity_per_minute: total_intensity / duration_minutes,
        seven_days_intensity: last_week_intensity.sum
      }
    end
  end
end
