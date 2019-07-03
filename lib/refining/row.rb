# Refining Namespace
# @since 0.1.0
module Refining
  # Simple value object for carry the matching values
  #
  # @author Joel Azemar
  # @since 0.1.0
  class Row
    # Id of the line
    # @return [Uuid]
    attr_accessor :id

    # Value to compared
    # @return [String]
    attr_accessor :value

    # Distance
    # @return [Integer]
    attr_accessor :distance

    # Distance
    # @return [Float]
    attr_accessor :rank

    # Initializer
    #
    # @author Joel Azemar
    #
    # @param [Uuid] id which we want compare close values
    # @param [String] value distance which flag as a match
    # @param [Integer] distance of the reference string
    # @param [Float] distance of the reference string
    def initialize(id:, value:, distance:, rank:)
      @id, @value, @distance, @rank = id, value, distance, rank
    end

    # Return Object Value as an Array
    # @return [Array]
    def to_a
      [ id, value, distance, rank ]
    end
  end
end
