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
      redirect_to @musician, notice: "#{@musician.name}を登録しました"
    else
      flash.now[:error] = '登録できませんでした'
      render :new
    end
  end

  private

  def musician_params
    params.require(:musician).permit(:name, :begun_in, :description)
  end
end
