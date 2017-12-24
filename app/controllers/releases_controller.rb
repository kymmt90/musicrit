class ReleasesController < ApplicationController
  def show
    @release = Release.find(params[:id])
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

  private

  def release_params
    params.require(:release).permit(:title, :released_on, :description)
  end
end
