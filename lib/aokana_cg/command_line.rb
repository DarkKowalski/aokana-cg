# frozen_string_literal: true

require 'optparse'

module AokanaCG
  class CommandLine
    def run(argv)
      options = {}
      OptionParser.new do |opts|
        opts.banner = 'Usage: aokana_cg [options]'

        opts.on('-v', '--version', 'Show version') do
          show_version
          exit
        end

        opts.on('-i', '--input INPUT', 'Input files') do |input|
          options[:input] = input
        end

        opts.on('-o', '--output OUTPUT', 'Output file') do |output|
          options[:output] = output
        end

        opts.on('-h', '--help', 'Show this message') do
          show_help_message
          exit
        end
      end.parse!(argv)

      if options[:input] && options[:output]
        merge(options)
      else
        warn 'Input and output files are required'
      end
    end

    def merge(options)
      input_files = options[:input].strip.split(',')
      output_file = options[:output]
      Util.auto_merge_and_save(input_files, output_file)

      puts "Merged #{input_files.size} files to #{output_file}"
    end

    def show_version
      puts VERSION
    end

    def show_help_message
      puts 'Usage: aokana_cg'
      puts '  -v, --version'
      puts '  -i <input>, --input <input>    # multiple files separated by comma'
      puts '  -o <output>, --output <output> # single file'
      puts '  -h, --help'
    end
  end
end
