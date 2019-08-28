require 'damerau-levenshtein'

# Refining Namespace
# @since 0.1.0
module Refining
  # Let find matches
  #
  # @author Joel Azemar
  # @since 0.1.0
  class Match
    # Initializer
    #
    # @author Joel Azemar
    #
    # @param [Array] dataset which we want compare close values
    # @param [String] Type of Algorithm
    # @param [Hash] Algorithm options
    def initialize(dataset:, algorithm: 'default', options:)
      @dataset    = dataset
      @algorithm  = algorithm
      @options    = options
    end

    # rubocop:disable Metrics/MethodLength

    # Find matches
    #
    # @author Joel Azemar
    #
    # @param [String] value to compare
    # @return [Array] Similar value found in the dataset
    def similarity(reference_row)
      result = Result.new

      result.reference = reference_row
      reference_value  = reference_row.value

      matcher = case algorithm
                when 'default'
                  Refining::Matches::Default.new(
                    dictionary: dataset_subset,
                    options: options
                  )
                when 'did_you_mean'
                  Refining::Matches::DidYouMean.new(
                    dictionary: dataset_subset,
                    options: options
                  )
                end

      corrections = matcher.correct(reference_value)

      result.similarities = corrections

      result
    end

    # rubocop:enable Metrics/MethodLength

    private

    # Dataset of values to be compared
    # @return [Array]
    attr_reader :dataset

    # Return the none updated records
    # @return [Array]
    def dataset_subset
      dataset.reject(&:updated?)
    end

    # Comparison method
    # @return [String]
    attr_reader :algorithm

    # Algorithm options
    # @return [Hash]
    attr_reader :options
  end
end
