class ReleasesController < ApplicationController
  before_action :set_release, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @musician = Musician.find(params[:musician_id])
  end

  def create
    @musician = Musician.find(params[:musician_id])
    @release = @musician.releases.build(release_params)
    if @release.save
      redirect_to musician_release_path(@musician, @release), notice: "#{@release.title}を登録しました"
    else
      flash.now[:error] = '登録できませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @release.update(release_params)
      redirect_to musician_release_path(@release.musician, @release), notice: "#{@release.title}を更新しました"
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @release.destroy!

    redirect_to musician_path(@release.musician), notice: "#{@release.title}を削除しました"
  end

  private

  def release_params
    params.require(:release).permit(:title, :released_on, :description)
  end

  def set_release
    @release = Release.find(params[:id])
  end
end
