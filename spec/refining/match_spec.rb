module Refining
  RSpec.describe Match do
    subject('match') do
      described_class.new(dataset: dataset, threshold: threshold,
        comparison: comparison)
    end

    let(:dataset) do
      [
        'Freedom, Inc.',
        'Freedom Inc.',
      ]
    end
    let(:comparison) { :loose }

    context 'with close value' do
      let(:value)     { 'Freedom Inc' }
      let(:threshold) { 2 }

      it do
        expect(match.similarity(value)).to eql(dataset)
      end
    end

    context 'with less close value' do
      let(:value)     { 'Freedom' }
      let(:threshold) { 6 }

      it do
        expect(match.similarity(value)).to eql(dataset)
      end
    end
  end
end
