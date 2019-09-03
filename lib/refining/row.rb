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
    attr_reader :id

    # Value to compared
    # @return [String]
    attr_accessor :value

    # Original Value
    # @return [String]
    attr_reader :original_value

    # Distance
    # @return [Integer]
    attr_accessor :distance

    # Distance
    # @return [Float]
    attr_accessor :rank

    # Distance
    # @return [Float]
    attr_accessor :updated

    # Initializer
    #
    # @author Joel Azemar
    #
    # @param [Uuid] id which we want compare close values
    # @param [String] value distance which flag as a match
    # @param [Integer] distance of the reference string
    # @param [Float] distance of the reference string
    def initialize(
      id: SecureRandom.uuid,
      original_value: nil,
      value:,
      distance: 'N/A',
      rank: 'N/A'
    )

      @id, @value, @distance, @rank = id, value, distance, rank
      @original_value = original_value
      @original_value ||= value
      @updated = false
    end

    # Predicate give the row state
    # @return [Boolean]
    def updated?
      updated
    end

    # Headers
    # @return [Array]
    def self.headers
      HEADERS
    end

    # Return Object Value as an Array
    # @return [Array]
    def to_a
      [ id, original_value, value, distance, rank ]
    end

    # Return Object Value as an String
    # @return [Array]
    def to_s
      "#{to_a.join(',')}\n"
    end

    HEADERS = [ 'Id', 'Original Value', 'New Value', 'Distance', 'Rank' ].freeze
    private_constant :HEADERS
  end
end
