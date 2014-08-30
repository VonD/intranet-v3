require 'test_helper'

class AccountingEntryTest < ActiveSupport::TestCase

	test "it monetizes amount with an integer" do
		accounting_entry = AccountingEntry.new(amount: 1000)
		assert_equal 100000, accounting_entry.amount_cents
	end

	test "it cannot have nil amount" do
		accounting_entry = AccountingEntry.new
		accounting_entry.amount = nil
		assert_equal 0, accounting_entry.amount
	end

	test "it forbids null amount" do
		accounting_entry = AccountingEntry.new
		accounting_entry.valid?
		assert accounting_entry.errors.include? :amount
	end

	test "it monetizes amount with a string" do
		accounting_entry = AccountingEntry.new
		[['10', 10], ['10,0', 10], ['10.35', 10.35], ['10,80', 10.8]].each do |amount|
			accounting_entry.amount = amount.first
			assert_equal amount.last, accounting_entry.amount
		end
	end

	test "it adds error on unparsable money" do
		accounting_entry = AccountingEntry.new(amount: "junk")
		accounting_entry.valid?
		assert accounting_entry.errors.include? :amount
	end

	test "it forbids empty date on create" do
		accounting_entry = AccountingEntry.new
		accounting_entry.valid?
		assert accounting_entry.errors.include? :date
	end

	test "it adds error on unparsable date" do
		accounting_entry = AccountingEntry.new(date: "2014-02-31")
		accounting_entry.valid?
		assert accounting_entry.errors.include? :date
		assert_equal 2, accounting_entry.errors[:date].length
	end

	test "it requires a bank_entry_id" do
		accounting_entry = AccountingEntry.new
		accounting_entry.valid?
		assert accounting_entry.errors.include? :bank_entry
	end

end
