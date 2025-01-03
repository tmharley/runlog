class WeatherTypesController < ApplicationController
  def index
    @weather_types = WeatherType.all.paginate(per_page: 20, page: params[:page])
    min_temp, max_temp = Run.pluck(:temperature).compact!.minmax
    @temp_counts = {}
    (min_temp / 5).upto(max_temp / 5).each do |temp_category|
      label = "#{temp_category * 5}&ndash;#{temp_category * 5 + 4}".html_safe
      @temp_counts[label] = Run.where(temperature: temp_category * 5...(temp_category + 1) * 5).count
    end
  end

  def new
    @weather_type = WeatherType.new
  end

  def edit
    @weather_type = WeatherType.find(params[:id])
  end

  def create
    @weather_type = WeatherType.new(weather_type_params)
    if @weather_type.save
      flash[:success] = 'Weather type was successfully created.'
      redirect_to weather_types_path
    else
      flash[:danger] = @weather_type.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    @weather_type = WeatherType.find(params[:id])
    if @weather_type.update(weather_type_params)
      flash[:success] = 'Weather type was successfully updated.'
      redirect_to weather_types_path
    else
      flash[:danger] = @weather_type.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @weather_type = WeatherType.find(params[:id])
    @weather_type.destroy
    flash[:success] = 'Weather type was successfully deleted.'
    redirect_to weather_types_path
  end

  private

  def weather_type_params
    params.require(:weather_type).permit(:name, :is_precip, :day_icon, :night_icon)
  end
end
