class MusiciansController < ApplicationController
  def index
    @musicians = Musician.all
  end
end
