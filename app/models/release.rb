class Release < ApplicationRecord
  belongs_to :musician

  has_many :tracks, dependent: :destroy

  validates :description, length: { minimum: 0, allow_nil: false }
  validates :released_on, format: { with: /\A[1-9]\d{0,3}-\d\d-\d\d\z/ }, presence: true
  validates :title, presence: true, uniqueness: { scope: [:musician, :released_on] }

  def build_tracks(params)
    params[:tracks].each_with_index do |param, index|
      tracks.build(title: param[:title], disc_number: 1, track_number: index + 1)
    end
  end

  def update_tracks!(params)
    transaction do
      track_ids_to_destroy(params[:tracks]).each { |id| tracks.find(id).destroy! }
      params[:tracks].each_with_index do |param, index|
        begin
          track = tracks.find(param[:id])
          track.update!(title: param[:title], disc_number: 1, track_number: index + 1)
        rescue ActiveRecord::RecordNotFound
          tracks.create!(title: param[:title], disc_number: 1, track_number: index + 1)
        end
      end
    end
  end

  private

  def track_ids_to_destroy(tracks_params)
    tracks.map(&:id) - tracks_params.map { |t| t[:id].to_i }
  end
end
