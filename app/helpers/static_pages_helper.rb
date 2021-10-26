module StaticPagesHelper
  include ActionView::Helpers::NumberHelper

  def total_mileage
    total = Run.pluck(:distance).reduce(:+)
    total.nil? ? 0 : number_with_delimiter(total.round(2))
  end

  def years
    all_years = Run.pluck(:start_time).map { |r| r.year }.uniq
    all_years.min..all_years.max
  end

  def mileage_for_year(year)
    distances = year_runs(year).pluck(:distance)
    return 0.00 if distances.empty?

    distances.reduce(:+).round(2)
  end

  def year_runs(year)
    Run.where(start_time: Time.new(year)..Time.new(year + 1))
  end

  def number_of_runs
    number_with_delimiter(Run.count)
  end

  def mileage_bar_visibility(year, max_year)
    if year < max_year - 6
      'd-none d-sm-none d-md-none d-lg-none d-xl-inline'
    elsif year < max_year - 4
      'd-none d-sm-none d-md-none d-lg-inline'
    elsif year < max_year - 2
      'd-none d-sm-none d-md-inline'
    end
  end
end
