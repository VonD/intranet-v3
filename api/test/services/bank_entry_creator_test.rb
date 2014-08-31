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
		group = groups(:one)
		creator = BankEntryCreator.new(amount: 120, group_id: group.id, accounting_entries: [
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
		assert_equal group.id, creator.accounting_entries.first.group_id
	end

	test "it requires at least one accounting_entry to be present" do
		creator = BankEntryCreator.new
		refute creator.save
		refute creator.bank_entry.persisted?
		assert creator.bank_entry.errors.include? :accounting_entries
	end

	test "it requires amounts to match" do
		creator = BankEntryCreator.new(amount: 140, accounting_entries: [
			{amount: 50, date: Date.today},
			{amount: 70, date: Date.today - 1.month}
		])
		refute creator.save
		refute creator.bank_entry.persisted?
		refute creator.accounting_entries.map(&:persisted?).any?
		assert creator.bank_entry.errors.include? :amount
	end

	test "it requires dates sequence to be respected" do
		creator = BankEntryCreator.new(amount: 140, date: Date.today - 3.months, accounting_entries: [
			{amount: 50, date: Date.today},
			{amount: 70, date: Date.today - 1.month}
		])
		refute creator.save
		refute creator.bank_entry.persisted?
		refute creator.accounting_entries.map(&:persisted?).any?
		assert creator.bank_entry.errors.include? :date
	end

	test "it forbids creation of bank_entry with date within group inactive period" do
		group = groups(:two)
		group.is_active_from = Date.today + 1.day
		group.save!
		creator = BankEntryCreator.new(amount: 120, group_id: group.id, date: Date.today, accounting_entries: [
			{amount: 50, date: Date.today},
			{amount: 70, date: Date.today - 1.month}
		])
		refute creator.save
		refute creator.bank_entry.persisted?
		refute creator.accounting_entries.map(&:persisted?).any?
		assert creator.bank_entry.errors.include? :date
	end

end
