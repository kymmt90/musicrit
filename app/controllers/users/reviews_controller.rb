class Users::ReviewsController < ApplicationController
  def index
    @user = User.includes(reviews: [:musician, :release, :track]).find(params[:user_id])
  end
end
