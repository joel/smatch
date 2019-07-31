module Refining
  RSpec.describe Result do
    subject('result') { described_class.new }

    describe '#similarities?' do
      it { expect(result).not_to be_similarities }
    end
  end
end
