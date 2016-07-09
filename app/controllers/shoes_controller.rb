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
    @shoe = Shoe.new(params[:shoe])
    if @shoe.save
      flash[:success] = 'Shoe was successfully created.'
      redirect_to @shoe
    else
      render :new
    end
  end

  def update
    @shoe = Shoe.find(params[:id])
    if @shoe.update_attributes(params[:shoe])
      flash[:success] = 'Shoe was successfully updated.'
      redirect_to @shoe
    else
      render :edit
    end
  end

  def destroy
    @shoe = Shoe.find(params[:id])
    @shoe.destroy
  end
end
