module Refining
  RSpec.describe Row do
    subject('row') do
      described_class.new(id: id, value: value, distance: distance, rank: rank)
    end

    let(:id)       { SecureRandom.uuid }
    let(:value)    { 'whatever' }
    let(:distance) { 2 }
    let(:rank)     { 0.98 }

    describe '#to_a' do
      it { expect(row.to_a).to eql([ id, value, distance, rank ]) }
    end
  end
end
