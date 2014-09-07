class AccountingEntryCreator

	include EntryService

	attr_accessor :bank_entry, :accounting_entry

	def initialize bank_entry, params={}
		@bank_entry = bank_entry
		@group = bank_entry.group
		@accounting_entry = bank_entry.accounting_entries.build
		@params = params
		transfer_accounting_entries_params
	end

private

	def entries
		[accounting_entry]
	end

	def transfer_accounting_entries_params
		accounting_entry.group_id = @group.id
		accounting_entry.date = @params[:date] if @params[:date].present?
		accounting_entry.amount = @params[:amount] if @params[:amount].present?
	end

	def recalculate_bank_entry_amount
		bank_entry.amount = bank_entry.amount + accounting_entry.amount
	end

	def respects_date_sequence?
		return true if bank_entry.date.blank? || accounting_entry.date.blank? || accounting_entry.date <= bank_entry.date
		accounting_entry.errors.add :date, less_than_or_equal_to: bank_entry.date
		false
	end

	def validate
		[
			accounting_entry.valid?,
			group_is_active?,
			respects_date_sequence?
		].all?
	end

	def process
		recalculate_bank_entry_amount
	end

	def persist
		[bank_entry, accounting_entry].map(&:save).all?
	end

end
