class TracksController < ApplicationController
  def show
    musician = Musician.find(params[:musician_id])
    release = musician.releases.find(params[:release_id])
    @track = release.tracks.includes(reviews: :user).find(params[:id])
    if current_user
      @review = current_user.reviews.find_by(reviewable: @track)
    end
  end
end
