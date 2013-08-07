# -*- coding: UTF-8 -*-

# require 'ostruct'
# require 'optparse'


# def self.parse_command_line(argv = ::ARGV)
#   o = OpenStruct.new(:file => 'protocol.ledger')

#   # parse
#   OptionParser.new do |opts|
#     opts.banner = "Usage: ledger-formatter --path /file/that/you/want.ledger"
#     opts.on '-f', '--file=LEDGER_FILE', 'Ledger file to format' do |v|
#       o.file = v
#     end

#     opts.on("-t", "--test", "Self-Test") do |v|
#       o.selftest = v
#     end

#     opts.on_tail '-h', '--help', 'Print this help' do
#       puts opts
#       exit 0
#     end
#   end.parse! argv

#   return o if o.selftest

#   unless o.file
#     puts  "Please provide path to ledger file!"
#     exit
#   end
#   o
# end





module Ledger
  class Formatter
    attr_accessor :transactions

    def fill_from_string(str)
      @transactions = parse_transactions_from_string(str)
    end

    def fill_from_file(path)
      ledger_content = File.open(path, "r:UTF-8") do |f|
        f.read
      end
      fill_from_string(ledger_content)
    end

    def parse_transactions_from_string(str)
      simple_regex = /^2/  # hacky, we search for digit "2" in the beginning
      # split -> remove blanks -> prepend with "2"
      res = str.split(simple_regex).select{|x| x != ""}.map{|x| "2#{x}"}
      res.map{|x| Transaction.new(x)}
    end

    def sort!
      @transactions.sort!{|x,y| x.date <=> y.date}
    end

    def pretty_print

      max = (get_max_distance + 12)
      transactions.map{|x| x.indented_source(max)}.join("\n\n")
    end

    def transactions
      @transactions ||= []
    end

    def get_max_distance
      transactions.map{|x| x.max_account_length}.max
    end
  end
end