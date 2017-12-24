class ReleasesController < ApplicationController
  def show
    @release = Release.find(params[:id])
  end

  def new
    @musician = Musician.find(params[:musician_id])
    @release = @musician.releases.new
  end
end
