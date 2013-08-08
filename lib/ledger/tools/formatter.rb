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
      res = split_by_transactions(str)
      res.map{|x| Transaction.new(x)}
    end

    def split_by_transactions(str)
      # idea:
      # transaction is identified by a digit at beginning.
      # acounts are indented. to retain both (digit + rest of a single transaction), we
      # scan and split by the same regex and combine result afterwards
      front_digits = str.scan(/^\d{1}/)
      rest         = str.split(/^\d{1}/)

      # remove blanks
      rest         = rest.select{|x| x!= ""}
      front_digits = front_digits.select{|x| x!= ""}

      res = []
      rest.each_with_index{|x, idx| res << "#{front_digits[idx]}#{rest[idx]}" }
      res
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