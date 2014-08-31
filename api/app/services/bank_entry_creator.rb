class BankEntryCreator < BankEntryService

	def initialize params={}
		@bank_entry = BankEntry.new
		@accounting_entries = []
		super
	end

private

	def transfer_bank_entry_params
		if @params[:group_id].present?
			bank_entry.group_id = @params[:group_id]
			@group = bank_entry.group
		end
		bank_entry.amount = @params[:amount] if @params[:amount].present?
		bank_entry.date = @params[:date] if @params[:date].present?
		bank_entry.reference = @params[:reference] if @params[:reference].present?
	end

	def transfer_accounting_entries_params
		(@params[:accounting_entries] || []).each do |entry_params|
			entry = bank_entry.accounting_entries.build
			entry.group_id = @group.id if @group.present?
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

end
