class BankEntry < ActiveRecord::Base

	include HasParsedDates

	monetize :amount_cents, allow_nil: true

	has_many :accounting_entries, dependent: :destroy

end
