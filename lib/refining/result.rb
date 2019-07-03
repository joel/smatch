# Refining Namespace
# @since 0.1.0
module Refining
  # Wrapper for matches
  #
  # @author Joel Azemar
  # @since 0.1.0
  class Result
    # Value of reference
    # @return [Row]
    attr_accessor :reference

    # Similaires values
    # @return Array
    attr_accessor :similarities

    # Initializer
    #
    # @author Joel Azemar
    def initialize
      @similarities = []
    end

    # Predicate if the row carry similarities
    #
    # @author Joel Azemar
    #
    # @return [Boolean]
    def has_similarities?
      !similarities.empty?
    end

    # Predicate if the row is a perfect match
    #
    # @author Joel Azemar
    #
    # @return [Boolean]
    def same?
      similarities.size == 1 && similarities.first.distance == 0 # The same
    end

    # Return Object Value as an Array
    # @return [Array]
    def to_a
      a = []
      a << [ 'reference' ] + reference.to_a
      similarities.each { |similar| similar << [ 'duplicate' ] + similar.to_a }
      a
    end

    # Give all row ids
    # @return [Array]
    def to_ids
      @ids ||= [ reference.id ] + to_similarity_ids
    end

    # Give ids of similar string
    # @return [Array]
    def to_similarity_ids
      @similarity_ids ||= similarities.map(&:id)
    end
  end
end
