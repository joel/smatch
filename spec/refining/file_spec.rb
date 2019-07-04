module Refining
  RSpec.describe File do
    subject('file') { described_class.new(temp_file.path) }

    let(:csv_source) do
      [
        [ 'Id', 'Name'            ],
        [ 123,  'Onno Giller'     ],
        [ 456,  'Onno Giller Inc' ],
      ]
    end

    let(:csv_string) do
      CSV.generate do |csv|
        csv_source.each { |row| csv << row }
      end
    end

    let(:temp_file) do
      file = Tempfile.new(['input_file', '.csv'])
      file.write(csv_string)
      file.rewind
      file
    end

    describe '#load' do
      it do
        expect(file.load).to be_a(Array)
        expect(file.load.first.id).to eql('123')
        expect(file.load.first.value).to eql('Onno Giller')
      end
    end

    context 'with incremental filename' do
      let(:filename) { "#{::File.basename(temp_file.path, '.*')}-1.csv" }

      describe '#dump' do
        after { FileUtils.rm(filename) }

        it do
          expect { file.dump(file.load) }.to change {
            ::File.exist?(filename)
          }.to(true)
        end
      end
    end
  end
end
