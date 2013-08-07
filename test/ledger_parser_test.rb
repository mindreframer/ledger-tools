# -*- coding: UTF-8 -*-
require_relative 'test_helper'


describe "Ledger::LedgerParser" do
  describe :parse do
    before do
      @ledger = Ledger::LedgerParser.new fixture("ledger-default.csv")
    end

    it "parses all transactions" do
      @ledger.entries.size.must_equal 2
    end

    it "parses date and description" do
      @ledger.entries[0][:date].must_equal  "2013/07/05"
      @ledger.entries[0][:desc].must_equal  "SpreeGold"
    end

    it "parses accounts" do
      accounts = @ledger.entries[0][:accounts]
      accounts[0][:name].must_equal "Expenses:Leasure:EatingOut"
      accounts[0][:amount].must_equal 4.9

      accounts[1][:name].must_equal "Assets:Checking"
      accounts[1][:amount].must_equal -4.9
    end

    it "works with comments" do
      ledger = Ledger::LedgerParser.new fixture("ledger-default-comments.csv")
      ledger.entries.size.must_equal 2
    end
  end

  describe :balance do
    it "works"
  end

  describe :clean_money do

  end
end