module StaticPagesHelper
  include ActionView::Helpers::NumberHelper

  def total_mileage
    number_with_delimiter(Run.pluck(:distance).reduce(:+).round(2))
  end

  def years
    Run.pluck(:start_time).map {|r| r.year}.uniq
  end

  def mileage_for_year(year)
    year_runs(year).pluck(:distance).reduce(:+).round(2)
  end

  def year_runs(year)
    Run.where(start_time: Time.new(year)..Time.new(year+1))
  end
end
