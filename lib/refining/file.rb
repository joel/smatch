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

    # Load a file into the dataset
    #
    # @author Joel Azemar
    #
    # @return [Array] The dataset
    def load
      csv_source = CSV.parse(::File.open(file_path).read)
      csv_source.shift # remove headers
      csv_source.map do |row|
        Row.new(id: row[0], value: row[1])
      end
    end

    # Dump dataset into a file
    #
    # @author Joel Azemar
    #
    # @param [Array] dataset
    # @return [NilClass]
    def dump(dataset)
      ::File.open(filename, 'wb') do |file|
        dataset.each do |row|
          file.write(row.to_s)
        end
      end
      nil
    end

    private
    # The file path
    # @return [String]
    attr_reader :file_path

    # Give the original filename with incremental number appended
    #
    # @author Joel Azemar
    #
    # @return [String] new file name
    def filename
      r = Regexp.new(/(?<file_name>.*)-(?<num>[0-9]{1,2})\.csv/)
      if m = r.match(file_path)
        "#{m[:file_name]}-#{distance_level}.csv"
      else
        "#{::File.basename(file_path, '.*')}-1.csv"
      end
    end
  end
end
