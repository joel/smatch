module Refining
  RSpec.describe Updater do
    subject('updater') do
      described_class.new(dataset: dataset, result: result)
    end

    let(:dataset) do
      [
        [ SecureRandom.uuid, 'Freedom, Inc.' ],
        [ SecureRandom.uuid, 'Freedom Inc.'  ],
        [ SecureRandom.uuid, 'Freedom  Inc.' ],
      ]
    end

    let(:result) { Result.new }

    before do
      result.reference = Row.new(value: 'Freedom')
      result.similarities = dataset.map do |id, value|
        Row.new(id: id, value: value)
      end
    end

    describe '#update!' do
      it 'update similair results' do
        expect { updater.update! }
          .to change { result.similarities.map(&:value).uniq.size }
          .from(3).to(1)
      end

      context 'with updated result' do
        before { updater.update! }

        it 'keep original values' do
          expect(result.similarities.map(&:original_value).sort)
            .to eql(dataset.map { |e| e[1] }.sort)
        end

        it 'has one value' do
          expect(result.similarities.map(&:value).uniq).to eql(['Freedom'])
        end
      end
    end
  end
end
