module Refining
  RSpec.describe Row do
    subject('row') do
      described_class.new(id: id, value: value, distance: distance, rank: rank)
    end

    let(:id)        { SecureRandom.uuid }
    let(:value)     { 'whatever' }
    let(:new_value) { value }
    let(:distance)  { 2 }
    let(:rank)      { 0.98 }

    describe '#to_a' do
      it { expect(row.to_a).to eql([ id, new_value, value, distance, rank ]) }
    end

    describe '#to_s' do
      it do
        expect(row.to_s)
          .to eql("#{id},#{new_value},#{value},#{distance},#{rank}\n")
      end
    end
  end
end
