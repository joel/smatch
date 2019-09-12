module Refining
  RSpec.describe Row do
    subject('row') do
      described_class.new(
        id: id,
        value: value,
        distance: distance,
        rank: rank,
        extra_values: extra_values
      )
    end

    let(:id)        { SecureRandom.uuid }
    let(:value)     { 'whatever' }
    let(:new_value) { value }
    let(:distance)  { 2 }
    let(:rank)      { 0.98 }
    let(:extra_values) { %w[a b c d e f] }

    # rubocop:disable RSpec/ExampleLength
    describe '#to_a' do
      it do
        expect(row.to_a)
          .to eql(
            [
              id, new_value, value, distance, rank, false,
              'a', 'b', 'c', 'd', 'e', 'f'
            ]
          )
      end
    end
    # rubocop:enable RSpec/ExampleLength

    describe '#to_s' do
      it do
        expect(row.to_s)
          .to eql("#{id},#{new_value},#{value},#{distance},"\
            "#{rank},false,a,b,c,d,e,f\n")
      end
    end
  end
end
