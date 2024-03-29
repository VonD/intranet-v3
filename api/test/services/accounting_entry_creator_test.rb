require 'test_helper'

class AccountingEntryCreatorTest < ActiveSupport::TestCase

	test "it initializes with a bank_entry and parameters" do
		bank_entry = bank_entries(:one)
		creator = AccountingEntryCreator.new(bank_entry, {})
		assert_equal bank_entry.id, creator.bank_entry.id
	end

	test "it transfers bank_entry_id to accounting_entry" do
		bank_entry = bank_entries(:one)
		creator = AccountingEntryCreator.new(bank_entry, {})
		assert_equal bank_entry.id, creator.accounting_entry.bank_entry_id
	end

	test "it transfers group_id to accounting_entry" do
		bank_entry = bank_entries(:one)
		creator = AccountingEntryCreator.new(bank_entry, {})
		assert_equal bank_entry.group_id, creator.accounting_entry.group_id
	end

	test "it transfers params to accounting_entry" do
		bank_entry = bank_entries(:one)
		creator = AccountingEntryCreator.new(bank_entry, {date: Date.today, amount: 1234})
		assert_equal Date.today, creator.accounting_entry.date
		assert_equal 1234, creator.accounting_entry.amount
	end

	test "it validates accounting_entry" do
		bank_entry = bank_entries(:one)
		creator = AccountingEntryCreator.new(bank_entry, {})
		creator.save
		assert creator.accounting_entry.errors.include?(:amount)
	end

	test "it forbids date in group inactivity period" do
		bank_entry = bank_entries(:one)
		group = bank_entry.group
		group.is_active_from = Date.today
		group.save!
		creator = AccountingEntryCreator.new(bank_entry, {date: Date.today - 1.day})
		creator.save
		assert creator.accounting_entry.errors.include?(:date)
	end

	test "it updates bank_entry amount" do
		bank_entry = bank_entries(:one)
		amount = bank_entry.amount
		group = bank_entry.group
		group.is_active_from = bank_entry.date
		group.save!
		creator = AccountingEntryCreator.new(bank_entry, {date: bank_entry.date, amount: 50})
		creator.save
		assert_equal amount + 50.to_money, creator.bank_entry.amount
	end

	test "it ensures dates sequence if bank_entry has a date" do
		bank_entry = bank_entries(:one)
		amount = bank_entry.amount
		group = bank_entry.group
		group.is_active_from = bank_entry.date
		group.save!
		creator = AccountingEntryCreator.new(bank_entry, {date: bank_entry.date + 1.day, amount: 50})
		creator.save
		assert creator.accounting_entry.errors.include? :date
	end

end
