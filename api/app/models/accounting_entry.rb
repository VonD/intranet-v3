class AccountingEntry < ActiveRecord::Base

	include HasParsedDates

	monetize :amount_cents

	belongs_to :bank_entry
	belongs_to :group

	validate :amount_is_not_null
	validates_presence_of :date
	validates_presence_of :bank_entry
	validates_presence_of :group

private

	def amount_is_not_null
		return true unless amount == 0
		errors.add :amount, greater_than: 0
		false
	end

end
