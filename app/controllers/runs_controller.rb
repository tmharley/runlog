class RunsController < ApplicationController
  def index
    criteria = {}

    if params[:year]
      year = params[:year].to_i
      criteria[:start_time] = Time.new(year)..Time.new(year+1)
    end

    if params[:type]
      if params[:type] == 'race'
        criteria[:is_race] = true
      end
    end

    if criteria.any?
      run_list = Run.where(criteria)
    else
      run_list = Run.all
    end

    @all_runs = run_list.sort {|a, b| b.start_time <=> a.start_time}
    @runs = @all_runs.paginate(per_page: 20, page: params[:page])

    respond_to do |format|
      format.html
      format.xml { render xml: @all_runs }
    end
  end

  def show
    @run = Run.find(params[:id])
    @shoe = Shoe.find(@run.shoe_id) rescue nil

    respond_to do |format|
      format.html
      format.xml { render xml: @run }
    end
  end

  def new
    @run = Run.new
  end

  def edit
    @run = Run.find(params[:id])
  end

  def create
    convert_datetime_to_local("start_time")
    @run = Run.new(params[:run])
    if @run.save
      Run.sip_stats = nil
      Run.average_distance = nil
      Run.average_temperature = nil
      Run.average_hills = nil
      flash['success'] = 'Run was successfully created.'
      redirect_to @run
    else
      render action: "new"
    end
  end

  def update
    convert_datetime_to_local("start_time")
    @run = Run.find(params[:id])
    if @run.update_attributes(params[:run])
      Run.sip_stats = nil
      Run.average_distance = nil
      Run.average_temperature = nil
      Run.average_hills = nil
      flash['success'] = 'Run was successfully updated.'
      redirect_to @run
    else
      render action: "edit"
    end
  end

  def destroy
    @run = Run.find(params[:id])
    @run.destroy
    @average_distance = nil
    @average_temperature = nil
    @average_hills = nil
  end

  def convert_datetime_to_local(field)
    datetime = (1..5).collect {|num| params['run'].delete "#{field}(#{num}i)" }
    if datetime[0] and datetime[1] and datetime[2]
      params['run'][field] = Time.find_zone!("Eastern Time (US & Canada)").local(*datetime.map(&:to_i))
    end
  end

end
