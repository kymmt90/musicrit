class MusiciansController < ApplicationController
  before_action :set_musician, only: [:show, :edit, :update, :destroy]

  def index
    @musicians = Musician.all
  end

  def show
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

  def edit
  end

  def update
    if @musician.update(musician_params)
      redirect_to @musician, notice: "#{@musician.name}を更新しました"
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @musician.destroy!

    redirect_to musicians_path, notice: "#{@musician.name}を削除しました"
  end

  private

  def musician_params
    params.require(:musician).permit(:name, :begun_in, :description)
  end

  def set_musician
    @musician = Musician.find(params[:id])
  end
end
