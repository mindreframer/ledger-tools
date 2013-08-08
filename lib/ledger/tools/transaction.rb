# -*- coding: UTF-8 -*-
module Ledger
  class Transaction
    require 'date'

    INDENTATION   = "  "
    COMMENT_CHARS = ["#", ";", "%", "|", "*"]

    attr_reader :source
    def initialize(source)
      @source = source
    end

    def date
      @date ||= begin
        DateTime.parse(source.split( ).first)
      end
    end

    def indented_source(distance=40)
      single_transactions = split_source
      header_array        = single_transactions[0..0]

      # indent them all
      indented_transactions = single_transactions[1..-1].map do |trans|
        indent_single_transaction(distance, split_single_transaction(trans))
      end

      #join back with header to string
      (header_array + indented_transactions).join("\n")
    end

    def split_source
      @split_source ||= source.split("\n")
    end


    def split_single_transaction(trans)
      # we might not have any amount on transaction...
      r = trans.strip.split(/\s{2,}/, 2)

      if r.size == 1 # just return back
        [trans.strip]
      else
        r
      end
    end

    def indent_single_transaction(distance, trans)
      # we have amount
      if trans[1]

        adjusted = trans[1].rjust(distance - trans[0].size)
        "#{INDENTATION}#{trans.first}  #{adjusted}"
      else
        "#{INDENTATION}#{trans.first}"
      end
    end

    def max_account_length
      begin
        split_source[1..-1].map{|x|
          return 0 if is_comment?(x)
          x.strip.split(/\s{2,}/, 2).first.size
        }.max
      rescue Exception => e
        puts "******* ERROR on:  \n#{split_source.join("\n")}"
        return 0
      end
    end

    def is_comment?(line)
      stripped = line.strip
      stripped == "" || COMMENT_CHARS.any?{|x| stripped.start_with?(x)}
    end





    ######## rather new approach

    # will return hash with
    # - date
    # - payee name
    # - comment, if present
    # - accounts
    def parse
      res = {}
      res[:date]  = date
      res[:desc] = split_source[0].split(" " ,2).last
      res
    end
  end
end