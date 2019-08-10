class ShoesController < ApplicationController
  def index
    @shoes = Shoe.all.sort_by {|s|
      s.last_used.nil? ? Time.now : s.last_used
    }.reverse.paginate(per_page: 20, page: params[:page])
  end

  def show
    @shoe = Shoe.find(params[:id])

    respond_to do |format|
      format.html
      format.xml { render xml: @shoe }
    end
  end

  def new
    @shoe = Shoe.new
  end

  def edit
    @shoe = Shoe.find(params[:id])
  end

  def create
    @shoe = Shoe.new(shoe_params)
    if @shoe.save
      flash[:success] = 'Shoe was successfully created.'
      redirect_to @shoe
    else
      flash[:danger] = @shoe.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    @shoe = Shoe.find(params[:id])
    if @shoe.update_attributes(shoe_params)
      flash[:success] = 'Shoe was successfully updated.'
      redirect_to @shoe
    else
      flash[:danger] = @shoe.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @shoe = Shoe.find(params[:id])
    @shoe.destroy
    flash[:success] = 'Shoe was successfully deleted.'
    redirect_to shoes_url
  end

  private
  def shoe_params
    params.require(:shoe).permit(:manufacturer, :model, :color_primary, :color_secondary, :color_tertiary, :size)
  end
end
