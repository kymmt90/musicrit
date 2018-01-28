class Tracks::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_musician
  before_action :set_release
  before_action :set_review, only: [:edit, :update]
  before_action :set_track

  def new
    @review = @track.reviews.build
  end

  def create
    @review = current_user.reviews.build(review_params.merge(reviewable: @track))
    if @review.save
      redirect_to musician_release_track_path(@musician, @release, @track), notice: "#{@track.title}のレビューを公開しました"
    else
      flash.now[:error] = '公開できませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to musician_release_track_path(@musician, @release, @track), notice: "#{@track.title}のレビューを更新しました"
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def review_params
    params.require(:review).permit(:body)
  end

  def set_musician
    @musician = Musician.find(params[:musician_id])
  end

  def set_release
    @release = @musician&.releases.find(params[:release_id])
  end

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def set_track
    @track = @release&.tracks.find(params[:track_id])
  end
end
