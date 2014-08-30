require 'test_helper'

class BankEntryCreatorTest < ActiveSupport::TestCase

	test "it creates a bank_entry" do
		creator = BankEntryCreator.new(amount: 10, date: Date.today, reference: "VIR 237")
		creator.save
		assert creator.bank_entry.persisted?
	end

	test "it calls model validations" do
		creator = BankEntryCreator.new(amount: "junk", date: Date.today, reference: "VIR 237")
		refute creator.save
		assert creator.bank_entry.new_record?
		assert creator.bank_entry.errors.include? :amount
	end

end
