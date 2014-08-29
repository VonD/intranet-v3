require 'test_helper'

class BankEntryTest < ActiveSupport::TestCase
  
	test "it monetizes amount" do
		bank_entry = BankEntry.new(amount: 1000)
		assert_equal 100000, bank_entry.amount_cents
	end

end
