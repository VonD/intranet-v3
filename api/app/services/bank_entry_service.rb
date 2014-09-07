class BankEntryService

	include EntryService

	attr_accessor :bank_entry, :accounting_entries

	def initialize params={}
		@params = params
		transfer_bank_entry_params
		transfer_accounting_entries_params
	end

private

	def entries
		[bank_entry] + accounting_entries
	end 

	def persist
		bank_entry.save
	end

	def has_at_least_one_accounting_entry?
		return true if accounting_entries.length > 0
		bank_entry.errors.add :accounting_entries, greater_than: 0
		false
	end

	def amounts_match?
		sum = accounting_entries.map(&:amount).inject(:+)
		unless bank_entry.amount
			bank_entry.amount = sum
			true
		else
			return true if bank_entry.amount == sum
			bank_entry.errors.add :amount, equal_to: sum
			false
		end
	end

	def respects_date_sequence?
		return true if bank_entry.date.blank?
		accounting_dates = accounting_entries.map(&:date).reject(&:blank?)
		return true if accounting_dates.map{ |d| d <= bank_entry.date }.all?
		bank_entry.errors.add :date, greater_than_or_equal_to: accounting_dates.sort.last
		false
	end

end
