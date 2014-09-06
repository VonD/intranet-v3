class AccountingEntryCreator

	attr_accessor :bank_entry, :accounting_entry

	def initialize bank_entry, params={}
		@bank_entry = bank_entry
		@accounting_entry = bank_entry.accounting_entries.build
		@params = params
		transfer_accounting_entries_params
	end

	def save
		validate && persist
	end

private

	def transfer_accounting_entries_params
		accounting_entry.group_id = bank_entry.group_id
		accounting_entry.date = @params[:date] if @params[:date].present?
		accounting_entry.amount = @params[:amount] if @params[:amount].present?
	end

	def validate
		accounting_entry.valid?
	end

	def persist
		[bank_entry, accounting_entry].map(&:save).all?
	end

end
