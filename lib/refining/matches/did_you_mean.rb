# Refining Namespace
# @since 0.1.0
module Refining
  module Matches
    # Algorithm based on Levenshtein and JaroWinkler
    #
    # @author Joel Azemar
    # @since 0.1.0
    class DidYouMean
      # Initializer
      #
      # @author Joel Azemar
      #
      # @param [Array] dictionary, all the available value to compare
      # @param [Hash] options given to the algorithm
      def initialize(dictionary:, options: {})
        @dictionary = dictionary
        @options = options
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize

      # Find matches
      #
      # @author Joel Azemar
      #
      # @param [String] value to compare
      # @return [Array] Similar value found in the dictionary
      def correct(input)
        input     = normalize(input)
        threshold = input.length > 3 ? 0.834 : 0.77

        words = @dictionary.select do |word|
          ::DidYouMean::JaroWinkler.distance(
            normalize(word.value),
            input
          ) >= threshold
        end
        words.reject! { |word| input == word.value }
        words.sort_by! do |word|
          ::DidYouMean::JaroWinkler.distance(word.value, input)
        end
        words.reverse!

        # Correct mistypes
        threshold   = (input.length * 0.25).ceil
        corrections = words.select do |c|
          ::DidYouMean::Levenshtein.distance(
            normalize(c.value),
            input
          ) <= threshold
        end

        # Correct misspells
        if corrections.empty?
          corrections = words.select do |word|
            word   = normalize(word.value)
            length = input.length < word.length ? input.length : word.length

            ::DidYouMean::Levenshtein.distance(word, input) < length
          end.first(1)
        end

        corrections
      end

      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      private

      # Remove special caracter
      #
      # @author Joel Azemar
      #
      # @param [String] value
      # @return [String]
      def normalize(str_or_symbol) #:nodoc:
        str_or_symbol
      end

      # Algorithm options
      # @return [Hash]
      attr_reader :options
    end
  end
end
