module Refining
  RSpec.describe Result do
    subject('result') { described_class.new }

    describe '#have_similarities?' do
      it { expect(result).not_to have_similarities }
    end
  end
end
