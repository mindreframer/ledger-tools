# -*- coding: UTF-8 -*-

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

      max = (longest_account_name + 12)
      transactions.map{|x| x.indented_source(max)}.join("\n\n")
    end

    def transactions
      @transactions ||= []
    end

    def longest_account_name
      transactions.map{|x| x.max_account_length}.max
    end
  end
end