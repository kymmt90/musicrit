class MusiciansController < ApplicationController
  def index
    @musicians = Musician.all
  end

  def show
    @musician = Musician.find(params[:id])
  end

  def new
    @musician = Musician.new
  end

  def create
    @musician = Musician.new(musician_params)
    if @musician.save
      redirect_to @musician
    else
      render :new
    end
  end

  private

  def musician_params
    params.require(:musician).permit(:name, :begun_in, :description)
  end
end
