class WeatherTypesController < ApplicationController
  def index
    @weather_types = WeatherType.all.paginate(per_page: 20, page: params[:page])
  end

  def new
    @weather_type = WeatherType.new
  end

  def edit
    @weather_type = WeatherType.find(params[:id])
  end

  def create
    @weather_type = WeatherType.new(params[:weather_type])
    if @weather_type.save
      render action: :index, notice: 'Weather type was successfully created.'
    else
      render action: :new
    end
  end

  def update
    @weather_type = WeatherType.find(params[:id])
    if @weather_type.save
      render action: :index, notice: 'Weather type was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @weather_type = WeatherType.find(params[:id])
    @weather_type.destroy
    render action: :index
  end
end
