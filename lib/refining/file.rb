# Refining Namespace
# @since 0.1.0
module Refining
  # Load and Dump entries
  #
  # @author Joel Azemar
  # @since 0.1.0
  class File
    # Initializer
    #
    # @author Joel Azemar
    #
    # @param [String] file_path
    def initialize(file_path)
      @file_path = file_path
    end

    # rubocop:disable Metrics/MethodLength

    # Load a file into the dataset
    #
    # @author Joel Azemar
    #
    # @return [Array] The dataset
    def load
      csv_source = CSV.parse(::File.open(file_path).read)
      @original_headers = csv_source.shift # remove headers
      csv_source.map do |row|
        Row.new(
          id: row[0],
          original_value: row[1],
          value: row[2],
          distance: row[3],
          rank: row[4],
          extra_values: row[6..row.length]
        )
      end
    end
    # rubocop:enable Metrics/MethodLength

    # Dump dataset into a file
    #
    # @author Joel Azemar
    #
    # @param [Array] dataset
    # @return [NilClass]
    def dump(dataset)
      dataset.unshift(headers)

      csv_string = CSV.generate do |csv|
        dataset.each { |row| csv << row.to_a }
      end

      ::File.open(filename, 'wb') do |file|
        file.write(csv_string)
      end

      nil
    end

    # The headers + Extra headers provided
    # @return [Array]
    def headers
      Row.headers + original_headers[6..original_headers.length]
    end

    private

    # The file path
    # @return [String]
    attr_reader :file_path

    # The file path
    # @return [String]
    attr_reader :original_headers

    # Give the original filename with incremental number appended
    #
    # @author Joel Azemar
    #
    # @return [String] new file name
    def filename
      r = Regexp.new(/(?<file_name>.*)-(?<num>[0-9]{1,2})\.csv/)
      if (m = r.match(file_path))
        "#{m[:file_name]}-#{m[:num].to_i + 1}.csv"
      else
        "#{::File.basename(file_path, '.*')}-1.csv"
      end
    end
  end
end
