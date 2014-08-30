class BankEntryCreator

	attr_accessor :bank_entry, :accounting_entries

	def initialize params={}
		@params = params
		@bank_entry = BankEntry.new
		@accounting_entries = []
		transfer_bank_entry_params
		transfer_accounting_entries_params
	end

	def save
		validate && persist
	end

private

	def transfer_bank_entry_params
		bank_entry.amount = @params[:amount] if @params[:amount].present?
		bank_entry.date = @params[:date] if @params[:date].present?
		bank_entry.reference = @params[:reference] if @params[:reference].present?
	end

	def transfer_accounting_entries_params
		(@params[:accounting_entries] || []).each do |entry_params|
			entry = @bank_entry.accounting_entries.build
			entry.amount = entry_params[:amount] if entry_params[:amount].present?
			entry.date = entry_params[:date] if entry_params[:date].present?
			@accounting_entries.push entry
		end
	end

	def validate
		[
			bank_entry.valid?,
			accounting_entries.map(&:valid?).all?,
			has_at_least_one_accounting_entry?,
			amounts_match?
		].all?
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
			bank_entry.errors.add :amount, must_equal: sum
			false
		end
	end

end
