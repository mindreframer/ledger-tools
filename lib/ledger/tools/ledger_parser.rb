# -*- coding: UTF-8 -*-

module Ledger
  class LedgerParser

    attr_accessor :entries

    def initialize(ledger, options = {})
      @entries = []
      parse(ledger)
    end

    def parse(ledger)
      @entries = []
      date = desc = nil
      accounts = []
      ledger.strip.split("\n").each do |entry|
        next if entry =~ /^\s*$/ || entry =~ /^[^ \t\d]/
        if entry =~ /^([\d\/-]+)(\=[\d\/-]+)?(\s+[\*!]?\s*.*?)$/
          @entries << { :date => date.strip, :desc => desc.strip, :accounts => balance(accounts) } if date
          date = $1
          desc = $3
          accounts = []
        elsif date && entry =~ /^\s+([a-z\s:_\-]+)(\s*$|(\s+[\$\.,\-\d\+]+)($|\s+($|[^\$\.,\-\d\+])))/i
          accounts << { :name => $1.strip, :amount => clean_money($3) }
        else
          @entries << { :date => date.strip, :desc => desc.strip, :accounts => balance(accounts) } if date
          date = desc = nil
          accounts = []
        end
      end
      @entries << { :date => date.strip, :desc => desc.strip, :accounts => balance(accounts) } if date
    end

    def balance(accounts)
      if accounts.any? { |i| i[:amount].nil? }
        sum = accounts.inject(0) {|m, account| m + (account[:amount] || 0) }
        count = 0
        accounts.each do |account|
          if account[:amount].nil?
            count += 1
            account[:amount] = 0 - sum
          end
        end
        if count > 1
          puts "Warning: unparsable entry due to more than one missing money value."
          p accounts
          puts
        end
      end

      accounts
    end

    def clean_money(money, options ={})
      cent_separator = options[:comma_separates_cents] ? "," : "."
      return nil if money.nil? || money.length == 0
      money_regex = %r[[^0-9#{cent_separator}-]]
      money.gsub(money_regex, '').gsub(cent_separator, '.').to_f
    end
  end
end
