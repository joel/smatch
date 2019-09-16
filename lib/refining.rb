require_relative 'refining/version'
require_relative 'refining/match'
require_relative 'refining/matches/default'
require_relative 'refining/matches/did_you_mean'
require_relative 'refining/row'
require_relative 'refining/result'
require_relative 'refining/updater'
require_relative 'refining/file'

require 'securerandom'
require 'csv'
require 'tty-prompt'
require 'terminal-table'
require 'optparse'
require 'optparse/date'
require 'did_you_mean'

require 'pry'

# Refining Namespace
# @since 0.1.0
module Refining
  class Error < StandardError; end

  # rubocop:disable Metrics/ClassLength

  # Control Inputs and Outputs of the program
  #
  # @author Joel Azemar
  # @since 0.1.0
  class Main
    # Initializer
    #
    # @author Joel Azemar
    def initialize
      @options = {}
      @distance_level = 2
      @options[:exclude] = []
      return unless ::File.exist?('.exclude_list')

      CSV.parse(::File.open('.exclude_list').read).each do |row|
        @options[:exclude] << row[0]
      end
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/PerceivedComplexity

    # Main method of CLI
    #
    # @author Joel Azemar
    #
    # @return [NilCalss]
    def start
      if options.empty? || options[:file_path].empty?
        help(option_parser)
        exit(0)
      end

      @options[:algorithm_name] ||= 'default'
      @options[:skip] ||= []

      prompt = TTY::Prompt.new

      choices = [
        { name: 'equal',            value: 0 },
        { name: 'close',            value: 1 },
        { name: 'relatively close', value: 2 },
        { name: 'not that close',   value: 3 },
        { name: 'far',              value: 4 },
        { name: 'far away',         value: 5 },
        { name: 'far far away',     value: 6 },
      ]
      @distance_level = prompt.enum_select(
        'Select a distance?',
        choices,
        default: 2
      )

      file = File.new(options[:file_path])
      dataset = file.load
      @headers = file.headers
      matcher = Match.new(dataset: dataset,
                          algorithm: options[:algorithm_name],
                          options: {
                            threshold: distance_level,
                            comparison: :strict
                          })

      data = dataset.dup
      count = 0

      while (row = data.pop)
        count += 1

        if count.zero? || (data.size % 10).zero?
          puts("data.size: #{data.size}") if options[:verbose]
        end

        result = matcher.similarity(row)
        next unless result.similarities?

        if @options[:max]
          next if result.similarities.size > @options[:max]
        end

        next if @options[:skip].include?(result.reference.value)
        next if @options[:exclude].any? do |expression|
          result.reference.value.match(Regexp.new(expression))
        end

        print_data(result)

        apply = false
        begin
          apply = prompt.yes?('Apply?') do |q|
            q.default false
          end
        rescue TTY::Prompt::ConversionError
          next
        end

        # rubocop:disable Style/IfUnlessModifier
        if apply == true
          Updater.new(dataset: dataset, result: result).update!
        end
        # rubocop:enable Style/IfUnlessModifier
      end
    rescue SystemExit, Interrupt, TTY::Reader::InputInterrupt
      puts 'Interruption!'
    ensure
      if file
        puts 'Saving file...'
        file.dump(dataset)
      end
      puts 'Bye'
      nil
    end

    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/PerceivedComplexity

    # rubocop:disable Metrics/MethodLength

    # CLI options
    #
    # @author Joel Azemar
    #
    # @return [OptionParser]
    def option_parser
      @option_parser ||= begin
        opts = OptionParser.new

        opts.banner = 'Usage: example.rb [options]'

        opts.on(
          '-f INPUT_CSV_FILE_PATH',
          '--file INPUT_CSV_FILE_PATH', '[REQUIRED] File path',
          String
        ) do |file_path|
          @options[:file_path] = file_path
        end

        opts.on(
          '-a ALGORITHM',
          '--algorithm ALGORITHM', '[OPTIONAL] Algorithm name',
          String
        ) do |algorithm_name|
          @options[:algorithm_name] = algorithm_name
        end

        opts.on(
          '-s SKIP',
          "--skip 'NoVo,Hewlett Foundation,Wallace Global Fund'",
          '[OPTIONAL] Skip words',
          Array
        ) do |skip|
          @options[:skip] = skip
        end

        opts.on(
          '-m MAX',
          '--max 10',
          '[OPTIONAL] Max similarities',
          Integer
        ) do |max|
          @options[:max] = max
        end

        opts.on(
          '-v',
          '--[no-]verbose', '[OPTIONAL] Run verbosely'
        ) do |verbose|
          @options[:verbose] = verbose
        end

        opts.on_tail('--version', 'Show version') do
          puts VERSION
          exit
        end

        opts.on('-h', '--help', 'Prints this help') do
          help(opts)
          exit(0)
        end

        opts
      end
    end

    # rubocop:enable Metrics/MethodLength

    private

    # CLI Options
    # @return [OptionParser]
    attr_reader :options

    # Distant between two sentences
    # @return [Integer]
    attr_reader :distance_level

    # Print out Help CLI options
    #
    # @author Joel Azemar
    #
    # @return [NilClass]
    def help(opts)
      puts(opts)
      puts('bin/refine --file file.csv')
      nil
    end

    # Print out senntences to compare
    #
    # @author Joel Azemar
    #
    # @return [String]
    def print_data(result)
      table = Terminal::Table.new do |t|
        t.headings = [ 'Type' ] + @headers
        t.rows = result.to_a
        t.style = { padding_left: 3, border_x: '=', border_i: 'x' }
      end

      puts table
    end
  end
  # rubocop:enable Metrics/ClassLength
end
