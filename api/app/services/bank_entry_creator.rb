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
		bank_entry.group_id = @params[:group_id] if @params[:group_id].present?
		bank_entry.amount = @params[:amount] if @params[:amount].present?
		bank_entry.date = @params[:date] if @params[:date].present?
		bank_entry.reference = @params[:reference] if @params[:reference].present?
	end

	def transfer_accounting_entries_params
		(@params[:accounting_entries] || []).each do |entry_params|
			entry = bank_entry.accounting_entries.build
			entry.group_id = bank_entry.group_id
			entry.amount = entry_params[:amount] if entry_params[:amount].present?
			entry.date = entry_params[:date] if entry_params[:date].present?
			@accounting_entries.push entry
		end
	end

	def validate
		[
			bank_entry.valid?,
			accounting_entries.map(&:valid?).all?,
			group_is_active?,
			has_at_least_one_accounting_entry?,
			amounts_match?,
			respects_date_sequence?
		].all?
	end

	def persist
		bank_entry.save
	end

	def group_is_active?
		return false if bank_entry.group.nil?
		return true if bank_entry.date.nil?
		return true if bank_entry.group.is_active_on?(bank_entry.date)
		bank_entry.errors.add :date, :group_must_be_active_at_this_date
		false
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
