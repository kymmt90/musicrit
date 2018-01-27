class Releases::ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @musician = Musician.find(params[:musician_id])
    @release = @musician.releases.find(params[:release_id])
    @review = @release.reviews.build
  end

  def create
    @musician = Musician.find(params[:musician_id])
    @release = @musician.releases.find(params[:release_id])
    @review = current_user.reviews.build(review_params.merge(reviewable: @release))
    if @review.save
      redirect_to musician_release_path(@musician, @release), notice: "#{@release.title}のレビューを公開しました"
    else
      flash.now[:error] = '公開できませんでした'
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:body)
  end
end
