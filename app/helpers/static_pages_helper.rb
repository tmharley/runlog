module StaticPagesHelper
  include ActionView::Helpers::NumberHelper

  def total_mileage
    total = Run.pluck(:distance).reduce(:+)
    total.nil? ? 0 : number_with_delimiter(total.round(2))
  end

  def years
    all_years = Run.pluck(:start_time).map {|r| r.year}.uniq
    all_years.min..all_years.max
  end

  def mileage_for_year(year)
    distances = year_runs(year).pluck(:distance)
    return 0.00 if distances.empty?
    distances.reduce(:+).round(2)
  end

  def year_runs(year)
    Run.where(start_time: Time.new(year)..Time.new(year+1))
  end
end
