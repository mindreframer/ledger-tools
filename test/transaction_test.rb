require_relative 'test_helper'

describe "Ledger::Transaction" do
  before do
    s = <<-SOURCE.deindent
    2013/07/05 SpreeGold
      Expenses:Leasure:EatingOut         4.90 Euro
      Assets:Checking
    SOURCE

    @transaction = Ledger::Transaction.new(s)
  end

  describe :date do
    it "parses the correct date" do
      @transaction.date.must_equal DateTime.new(2013, 7, 5)
    end
  end

  describe :split_single_transaction do
    it "works correctly" do
      variations = [
        ["Expenses:Leasure:EatingOut         4.90 Euro", ["Expenses:Leasure:EatingOut", "4.90 Euro"] ],
        ["    Expenses:Leasure:EatingOut         4.90 Euro", ["Expenses:Leasure:EatingOut", "4.90 Euro"] ],
        ["    Expenses:Leasure:EatingOut         4.90 Euro; comment", ["Expenses:Leasure:EatingOut", "4.90 Euro; comment"] ],
        ["* Assets:Checking", ["* Assets:Checking"] ],
      ]
      variations.each do |var|
        @transaction.split_single_transaction(var[0]).must_equal var[1]
      end
    end
  end

  describe :indent_single_transaction do
    it "works" do
      trans = ["Expenses:Leasure:EatingOut", "4.90 Euro"]
      expected = "  Expenses:Leasure:EatingOut            4.90 Euro"
      @transaction.indent_single_transaction(45, trans).must_equal expected
    end
  end

  describe :indented_source do
    it "works" do
      expected = <<-EXP.indent_to_least_space
      2013/07/05 SpreeGold
        Expenses:Leasure:EatingOut       4.90 Euro
        Assets:Checking
      EXP
      #binding.pry
      @transaction.indented_source(40).must_equal expected
    end
  end

  # describe :is_comment? do
  #   it "works" do
  #     comments = [
  #       "; asdfasd",
  #       "# asdfasd",
  #       "% asdfasd",
  #       "| asdfasd"
  #     ]
  #     comments.each do |comment|
  #       @transaction.is_comment?(comment).must_be_true
  #     end
  #   end
  # end

  describe :max_account_length do
    it "works" do
      @transaction.max_account_length.must_equal 26
    end
  end

  describe :parse do
    it "works" do
      res = @transaction.parse
      res[:date].must_equal DateTime.new(2013, 7,5)
      res[:desc].must_equal "SpreeGold"
    end
  end
end
