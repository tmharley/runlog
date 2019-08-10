class RunsController < ApplicationController
  def index
    criteria = {}

    if params[:filter_date]
      begin_time = Time.new(*params[:start_date].split('-')).beginning_of_day
      end_time = Time.new(*params[:end_date].split('-')).end_of_day
      criteria[:start_time] = begin_time..end_time
    end
    
    criteria[:distance] = params[:min_dist]..params[:max_dist] if params[:filter_dist]
    criteria[:temperature] = params[:min_temp]..params[:max_temp] if params[:filter_temp]
    criteria[:is_race] = true if params[:type] == 'race'

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
      flash[:success] = 'Run was successfully created.'
      redirect_to @run
    else
      flash[:danger] = @run.errors.full_messages
      render :new
    end
  end

  def update
    convert_datetime_to_local("start_time")
    @run = Run.find(params[:id])
    if @run.update(run_params)
      flash[:success] = 'Run was successfully updated.'
      redirect_to @run
    else
      flash[:danger] = @run.errors.full_messages
      render :edit
    end
  end

  def destroy
    @run = Run.find(params[:id])
    @run.destroy
    flash[:success] = 'Run was successfully deleted.'
    redirect_to action: :index
  end

  def search
    date = Time.now
    @start_date = (date - 1.year).strftime('%Y-%m-%d')
    @end_date = date.strftime('%Y-%m-%d')
  end

  private
	def run_params
		params.require(:run).permit(:distance, :elev_gain, :start_time_string, :temperature, :duration_string, :is_race, :notes, :race_name, :shoe_id, :is_night, :weather_type_id, :heart_rate)
	end

  def convert_datetime_to_local(field)
    datetime = (1..5).collect {|num| params['run'].delete "#{field}(#{num}i)" }
    if datetime[0] && datetime[1] && datetime[2]
      params['run'][field] = Time.find_zone!("Eastern Time (US & Canada)").local(*datetime.map(&:to_i))
    end
  end
end
