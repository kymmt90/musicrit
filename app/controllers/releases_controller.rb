class ReleasesController < ApplicationController
  before_action :set_musician
  before_action :set_release, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to @musician, status: :moved_permanently
  end

  def show
    if current_user
      @review = current_user.reviews.find_by(reviewable: @release)
    end
  end

  def new
    @release = @musician.releases.new
  end

  def create
    @release = @musician.releases.build(release_attributes_params)
    @release.build_tracks(track_params)

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
    @release.transaction do
      @release.update!(release_attributes_params)
      @release.update_tracks!(track_params)
    end

    redirect_to musician_release_path(@release.musician, @release), notice: "#{@release.title}を更新しました"

  rescue ActiveRecord::ActiveRecordError
    flash.now[:error] = '更新できませんでした'
    render :edit
  end

  def destroy
    @release.destroy!

    redirect_to musician_path(@release.musician), notice: "#{@release.title}を削除しました"
  end

  private

  def release_params
    params.require(:release).permit(:title, :released_on, :description, :cover, tracks: [:id, :title])
  end

  def release_attributes_params
    release_params.slice(:title, :released_on, :description, :cover)
  end

  def track_params
    release_params.slice(:tracks)
  end

  def set_musician
    @musician = Musician.find(params[:musician_id])
  end

  def set_release
    @release = @musician.releases.includes(reviews: :user).find(params[:id])
  end
end
