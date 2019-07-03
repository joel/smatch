# Refining Namespace
# @since 0.1.0
module Refining
  # Update string on similares results
  #
  # @author Joel Azemar
  # @since 0.1.0
  class Updater
    # The dataset
    # @return [Array]
    attr_reader :dataset

    # Carry the similares strings
    # @return [Result]
    attr_reader :result

    # Initializer
    #
    # @author Joel Azemar
    #
    # @param [Array] dataset
    # @param [Result] result
    def initialize(dataset: dataset, result: result)
      @dataset, @result = dataset, result
    end

    # Update similair results
    #
    # @author Joel Azemar
    #
    # @return [NilClass]
    def update!
      value = result.reference.value
      result.similarities.each do |row|
        row.value = value
      end
      nil
    end
  end
end
