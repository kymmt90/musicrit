class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_musician, only: [:new, :create]

  def index
    @user = User.includes(reviews: [:musician]).find(params[:user_id])
  end

  def new
    @review = @musician.reviews.new
  end

  def create
    @review = current_user.reviews.new(review_params.merge(reviewable: @musician))
    if @review.save
      redirect_to musician_path(@musician), notice: "#{@musician.name}のレビューを公開しました"
    else
      flash.now[:error] = '公開できませんでした'
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:body)
  end

  def set_musician
    @musician = Musician.find(params[:musician_id])
  end
end
