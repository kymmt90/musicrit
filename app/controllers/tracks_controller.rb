class TracksController < ApplicationController
  def show
    musician = Musician.find(params[:musician_id])
    release = musician.releases.find(params[:release_id])
    @track = release.tracks.find(params[:id])
  end
end
