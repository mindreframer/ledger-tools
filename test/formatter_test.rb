# -*- coding: UTF-8 -*-
require_relative 'test_helper'


describe "Ledger" do
      before do
        @ledger = Ledger::Formatter.new
      end

      describe "parsing" do
        before do
          @ledger_content                   = fixture('ledger-default.csv')
          @ledger_content_unsorted          = fixture("ledger-unsorted.csv")
          @ledger_content_for_max           = fixture('ledger-long-account-name.csv')
          @ledger_content_for_max           = fixture('ledger-long-account-name-formatted.csv')
          @ledger_content_for_max_formatted = fixture('ledger-long-account-name-formatted.csv')
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

        describe :longest_account_name do
          it "returns the length of longest account name from transactions" do
            str = "Expenses:Leasure:EatingOut:Vegetarian"
            @ledger.fill_from_string(@ledger_content_for_max)
            @ledger.longest_account_name.must_equal str.size
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
