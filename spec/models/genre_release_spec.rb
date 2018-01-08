require 'rails_helper'

RSpec.describe GenreRelease, type: :model do
  describe '#genre' do
    subject { build_stubbed(:genre_release) }
    it { should respond_to :genre }
  end

  describe '#release' do
    subject { build_stubbed(:genre_release) }
    it { should respond_to :release }
  end
end
