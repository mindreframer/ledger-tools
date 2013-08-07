module Ledger
  class OptionParser
    require 'ostruct'
    require 'optparse'

    def self.parse_formatter_options(argv = ::ARGV)
      o = OpenStruct.new(:file => nil)

      # parse
      ::OptionParser.new do |opts|
        opts.banner = "Usage: ledger-formatter --path /file/that/you/want.ledger"
        opts.on '-f', '--file=LEDGER_FILE', 'Ledger file to format' do |v|
          o.file = v
        end

        opts.on_tail '-h', '--help', 'Print this help' do
          puts opts
          exit 0
        end
      end.parse! argv

      unless o.file
        puts  "Please provide path to ledger file! Use `-f` for this. "
        exit
      end
      o

    end
  end
end