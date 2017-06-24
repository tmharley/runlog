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

    run_list = if criteria.any?
                 Run.where(criteria).order(start_time: :desc)
               else
                 Run.all.order(start_time: :desc)
               end

    @runs = run_list.paginate(per_page: 20, page: params[:page])

    respond_to do |format|
      format.html
      format.xml { render xml: run_list }
      format.json { render json: run_list }
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
    @run = Run.new(run_params)
    if @run.save
      #Run.sip_stats = nil
      #Run.average_distance = nil
      #Run.average_temperature = nil
      #Run.average_hills = nil
      flash[:success] = 'Run was successfully created.'
      redirect_to @run
    else
      render :new
    end
  end

  def update
    convert_datetime_to_local("start_time")
    @run = Run.find(params[:id])
    if @run.update(run_params)
      #Run.sip_stats = nil
      #Run.average_distance = nil
      #Run.average_temperature = nil
      #Run.average_hills = nil
      flash[:success] = 'Run was successfully updated.'
      redirect_to @run
    else
      render :edit
    end
  end

  def destroy
    @run = Run.find(params[:id])
    @run.destroy
    @average_distance = nil
    @average_temperature = nil
    @average_hills = nil
    redirect_to action: :index
  end

  private
	def run_params
		params.require(:run).permit(:distance, :elev_gain, :start_time_string, :temperature, :duration_string, :is_race, :notes, :race_name, :shoe_id, :is_night, :weather_type_id)
	end

  def convert_datetime_to_local(field)
    datetime = (1..5).collect {|num| params['run'].delete "#{field}(#{num}i)" }
    if datetime[0] && datetime[1] && datetime[2]
      params['run'][field] = Time.find_zone!("Eastern Time (US & Canada)").local(*datetime.map(&:to_i))
    end
  end
end
