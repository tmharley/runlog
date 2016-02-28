module StaticPagesHelper
  def total_mileage
    Run.all.inject(0) { |a,b| a = a + b.distance }.round(2)
  end

  def years
    Run.pluck(:start_time).map {|r| r.year}.uniq
  end

  def mileage_for_year(year)
    year_runs(year).inject(0) { |a,b| a = a + b.distance }.round(2)
  end

  def year_runs(year)
    Run.where(start_time: Time.new(year)..Time.new(year+1))
  end
end
