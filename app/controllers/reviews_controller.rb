class ReviewsController < ApplicationController
  def index
    @user = User.includes(reviews: [:musician]).find(params[:user_id])
  end
end
