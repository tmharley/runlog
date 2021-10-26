class StaticPagesController < ApplicationController
  def home; end

  def training
    @last_week_runs = Run.last_week
    @acute = Run.mileage_in_last_days(7)
    @chronic = Run.mileage_in_last_days(28)
    trimps = @last_week_runs.map(&:training_impulse)
    @monotony = if trimps.length > 1
                  (trimps.mean / trimps.stdev).round(2)
                else
                  'Requires at least 2 runs to calculate'
                end
  end
end
