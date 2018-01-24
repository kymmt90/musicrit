class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_musician, only: [:new, :create, :edit, :update]
  before_action :set_review, only: [:edit, :update]

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

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to musician_path(@musician), notice: "#{@musician.name}のレビューを更新しました"
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

  def set_review
    @review = @musician.reviews.find(params[:id])
  end
end
