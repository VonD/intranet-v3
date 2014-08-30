require 'test_helper'

class BankEntryTest < ActiveSupport::TestCase
  
	test "it monetizes amount with an integer" do
		bank_entry = BankEntry.new(amount: 1000)
		assert_equal 100000, bank_entry.amount_cents
	end

	test "it allows nil amount" do
		bank_entry = BankEntry.new
		assert_nil bank_entry.amount
		assert bank_entry.valid?
	end

	test "it monetizes amount with a string" do
		bank_entry = BankEntry.new
		[['10', 10], ['10,0', 10], ['10.35', 10.35], ['10,80', 10.8]].each do |amount|
			bank_entry.amount = amount.first
			assert_equal amount.last, bank_entry.amount
		end
	end

	test "it adds error on unparsable money" do
		bank_entry = BankEntry.new(amount: "junk")
		refute bank_entry.valid?
		assert bank_entry.errors.include? :amount
	end

end
