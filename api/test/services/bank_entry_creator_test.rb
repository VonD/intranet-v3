require 'test_helper'

class BankEntryCreatorTest < ActiveSupport::TestCase

	test "it calls model validations on bank_entry" do
		creator = BankEntryCreator.new(amount: "junk", date: Date.today, reference: "VIR 237")
		refute creator.save
		assert creator.bank_entry.new_record?
		assert creator.bank_entry.errors.include? :amount
	end

	test "it calls model validations on accounting entries" do
		creator = BankEntryCreator.new(accounting_entries: [{amount: 0}])
		refute creator.save
		assert creator.bank_entry.new_record?
		assert creator.accounting_entries.first.new_record?
		assert creator.accounting_entries.first.errors.include? :amount
	end

	test "it transfers accounting entries params" do
		creator = BankEntryCreator.new(accounting_entries: [
			{amount: 50, date: Date.today},
			{amount: 70, date: Date.today - 1.month}
		])
		assert_equal 2, creator.bank_entry.accounting_entries.length
		assert_equal 50, creator.bank_entry.accounting_entries.first.amount
		assert_equal 70, creator.bank_entry.accounting_entries.last.amount
		assert_equal Date.today, creator.bank_entry.accounting_entries.first.date
		assert_equal Date.today - 1.month, creator.bank_entry.accounting_entries.last.date
	end

	test "it persists a bank entry with accounting entries" do
		creator = BankEntryCreator.new(amount: 120, accounting_entries: [
			{amount: 50, date: Date.today},
			{amount: 70, date: Date.today - 1.month}
		])
		creator.save
		assert creator.bank_entry.persisted?
		assert creator.accounting_entries.map(&:persisted?).all?
		assert_equal 2, creator.bank_entry.reload.accounting_entries.count
		ids = creator.accounting_entries.map(&:bank_entry_id).uniq
		assert_equal 1, ids.length
		assert_equal creator.bank_entry.id, ids.first
	end

	test "it requires at least one accounting_entry to be present" do
		creator = BankEntryCreator.new
		refute creator.save
		assert creator.bank_entry.errors.include? :accounting_entries
	end

end
