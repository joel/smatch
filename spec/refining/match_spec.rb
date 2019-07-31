module Refining
  RSpec.describe Match do
    subject('match') do
      described_class.new(
        dataset: dataset,
        threshold: threshold,
        comparison: comparison
      )
    end

    let(:dataset) do
      [ 'Freedom, Inc.', 'Freedom Inc.', 'Freedom  Inc.' ].map do |value|
        Row.new(value: value)
      end
    end

    context 'with close value' do
      let(:value)      { 'Freedom Inc' }
      let(:threshold)  { 2 }
      let(:comparison) { :loose }

      it do
        expect(match.similarity(Row.new(value: value))
          .similarities.map(&:value))
          .to eql(dataset.map(&:value))
      end
    end

    context 'with less close value' do
      let(:value)     { 'Freedom' }
      let(:threshold) { 7 }

      context 'with strict comparison method' do
        let(:comparison) { :strict }

        it do
          expect(match.similarity(Row.new(value: value)).similarities
            .map(&:value)).to eql([])
        end
      end

      context 'with all the way down comparison method' do
        let(:comparison) { :loose }

        it do
          expect(match.similarity(Row.new(value: value))
            .similarities.map(&:value))
            .to eql(dataset.map(&:value))
        end
      end
    end
  end
end
