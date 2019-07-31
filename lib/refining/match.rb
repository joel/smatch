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
    # @param [Integer] threshold distance which flag as a match
    # @param [Symbol] comparison method of comparison, :strict to take only
    # the same level of similarity
    def initialize(dataset:, threshold: 2, comparison: :strict)
      @dataset    = dataset
      @threshold  = threshold
      @comparison = comparison
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity

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

      dataset_subset.each do |row|
        current_value = row.value

        next if current_value.to_s.empty? ||
                (current_value.length > max_length ||
                current_value.length < min_length)

        gap = (current_value.length * 100 / reference_value.length)
        next if gap < min_interval || max_interval < gap

        # Levenshtein counts the number of edits (insertions, deletions, or
        # substitutions) needed to convert one string to the other.
        # Damerau-Levenshtein is a modified version that also considers
        # transpositions as single edits
        distance = DamerauLevenshtein.distance(reference_value, current_value)
        rank = (1 - (distance.to_f /
          (reference_value.length + current_value.length))).round(2)

        similar = case comparison
                  when :strict
                    distance == threshold
                  else
                    distance <= threshold
                  end

        next unless similar

        row.distance = distance
        row.rank = rank
        result.similarities << row
      end

      result
    end

    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

    private

    # Comparison method
    # @return [Symbol]
    attr_reader :comparison

    # Dataset of values to be compared
    # @return [Array]
    attr_reader :dataset

    # Minimun rank for the expected matches
    # @return [Integer]
    attr_reader :threshold

    MAX_LENGTH = 500
    private_constant :MAX_LENGTH

    # Return the none updated records
    # @return [Array]
    def dataset_subset
      dataset.reject(&:updated?)
    end

    # Maximum length for a string be suitable to compare
    # @return [Integer]
    def max_length
      MAX_LENGTH
    end

    MIN_LENGTH = 3
    private_constant :MIN_LENGTH

    # Minimun length for a string be suitable to compare
    # @return [Integer]
    def min_length
      MIN_LENGTH
    end

    MAX_INTERVAL = 500
    private_constant :MAX_INTERVAL

    # Maximum interval between the value and the string to compare
    # @return [Integer]
    def max_interval
      MAX_INTERVAL
    end

    MIN_INTERVAL = 3
    private_constant :MIN_INTERVAL

    # Minimum interval between the value and the string to compare
    # @return [Integer]
    def min_interval
      MIN_INTERVAL
    end
  end
end
