# -*- coding: UTF-8 -*-
require_relative 'test_helper'


describe "Ledger" do
      before do
        @ledger = Ledger::Formatter.new
      end

      describe "parsing" do
        before do
          @ledger_content  = <<-TRA.indent_to_least_space
          2013/07/05 SpreeGold
            Expenses:Leasure:EatingOut         4.90 Euro
            Assets:Checking

          2013/07/06 Turkish Restaurant
            Expenses:Leasure:EatingOut         13.00 Euro
            Assets:Checking

          TRA
          @ledger_content_unsorted  = <<-TRA.indent_to_least_space
          2013/08/05 SpreeGold
            Expenses:Leasure:EatingOut         4.90 Euro
            Assets:Checking

          2013/07/06 Turkish Restaurant
            Expenses:Leasure:EatingOut         13.00 Euro
            Assets:Checking

          TRA

          @ledger_content_for_max  = <<-TRA.indent_to_least_space
          2013/08/05 SpreeGold
            Expenses:Leasure:EatingOut:Vegetarian         4300.90 Euro
            Assets:Checking

          2013/07/06 Turkish Restaurant
            Expenses:Leasure:EatingOut    13.00 Euro
            Assets:Checking

          TRA

          @ledger_content_for_max_formatted  = <<-TRA.indent_to_least_space
          2013/08/05 SpreeGold
            Expenses:Leasure:EatingOut:Vegetarian  4300.90 Euro
            Assets:Checking

          2013/07/06 Turkish Restaurant
            Expenses:Leasure:EatingOut               13.00 Euro
            Assets:Checking
          TRA

        end

        describe :fill_from_string do
          it "sets transactions variable" do
            @ledger.transactions.must_equal []
            @ledger.fill_from_string(@ledger_content)
            @ledger.transactions.size.must_equal 2
          end
        end

        describe :parse_transactions_from_string do
          it "does not set @transactions" do
            @ledger.transactions.must_equal []
            res = @ledger.parse_transactions_from_string(@ledger_content)
            res.size.must_equal 2
            res.first.class.to_s.must_equal "Ledger::Transaction"
            @ledger.transactions.must_equal []
          end
        end

        describe :sort! do
          it "supports sorting" do
            @ledger.fill_from_string(@ledger_content_unsorted)
            first_before = @ledger.transactions.first
            @ledger.sort!
            @ledger.transactions.first.wont_equal first_before
          end
        end

        describe :get_max_distance do
          it "returns the length of longest account name from transactions" do
            str = "Expenses:Leasure:EatingOut:Vegetarian"
            @ledger.fill_from_string(@ledger_content_for_max)
            @ledger.get_max_distance.must_equal str.size
          end
        end

        describe :pretty_print do
          it "supports formatting" do
            @ledger.fill_from_string(@ledger_content_for_max)
            @ledger.pretty_print.must_equal @ledger_content_for_max_formatted
          end
        end
      end
    end
