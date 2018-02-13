class Release < ApplicationRecord
  alias_attribute :name, :title

  belongs_to :musician

  has_many :genre_releases, dependent: :destroy
  has_many :genres, through: :genre_releases
  has_many :tracks, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy

  has_one_attached :cover

  validates :description, length: { minimum: 0, allow_nil: false }
  validates :released_on, format: { with: /\A[1-9]\d{0,3}-\d\d-\d\d\z/ }, presence: true
  validates :title, presence: true, uniqueness: { scope: [:musician, :released_on] }

  def build_tracks(params)
    params[:tracks].each_with_index do |param, index|
      tracks.build(title: param[:title], disc_number: 1, track_number: index + 1)
    end
  end

  def update_from!(params)
    cover.purge if remove_cover?(params)
    update!(release_attribute_params(params))
    update_tracks!(tracks_params(params))
  end

  private

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

  def release_attribute_params(params)
    params.slice(:title, :released_on, :description, :cover)
  end

  def remove_cover?(params)
    params[:remove_cover] == '1'
  end

  def tracks_params(params)
    params.slice(:tracks)
  end

  def track_ids_to_destroy(tracks_params)
    tracks.map(&:id) - tracks_params.map { |t| t[:id].to_i }
  end
end
