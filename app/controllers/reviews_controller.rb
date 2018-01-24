class ReviewsController < ApplicationController
  def index
    @user = User.includes(reviews: [:musician]).find(params[:user_id])
  end

  def new
    @musician = Musician.find(params[:musician_id])
    @review = @musician.reviews.new
  end
end
