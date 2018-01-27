class Releases::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_musician
  before_action :set_release

  def new
    @review = @release.reviews.build
  end

  def create
    @review = current_user.reviews.build(review_params.merge(reviewable: @release))
    if @review.save
      redirect_to musician_release_path(@musician, @release), notice: "#{@release.title}のレビューを公開しました"
    else
      flash.now[:error] = '公開できませんでした'
      render :new
    end
  end

  def edit
    @review = @release.reviews.find(params[:id])
  end

  def update
    @review = current_user.reviews.find(params[:id])
    if @review.update(review_params)
      redirect_to musician_release_path(@musician, @release), notice: "#{@release.title}のレビューを更新しました"
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
end
