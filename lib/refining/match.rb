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
    def initialize(dataset: dataset, threshold: 2, comparison: :strict)
      @dataset    = dataset
      @threshold  = threshold
      @comparison = comparison
    end

    # Find matches
    #
    # @author Joel Azemar
    #
    # @param [String] value to compare
    # @return [Array] Similar value found in the dataset
    def similarity(id:, value:)
      result = Result.new
      result.reference = Row.new(id: id, value: value, distance: 0, rank: 1.00)

      dataset.each do |row|
        row_id, entry = row

        next if entry.to_s.empty? ||
          (entry.length > max_length || entry.length < min_length)

        gap = (entry.length * 100 / value.length)
        next if gap < min_interval || max_interval < gap

        # Levenshtein counts the number of edits (insertions, deletions, or
        # substitutions) needed to convert one string to the other.
        # Damerau-Levenshtein is a modified version that also considers
        # transpositions as single edits
        distance = DamerauLevenshtein.distance(value, entry)
        rank = (1 - (distance.to_f / (value.length + entry.length))).round(2)

        similar = false
        case comparison
        when :strict
          similar = distance == threshold
        else
          similar = distance <= threshold
        end

        if similar
          result.similarities << Row.new(id: row_id, value: entry,
            distance: distance, rank: rank)
        end
      end

      result
    end

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
