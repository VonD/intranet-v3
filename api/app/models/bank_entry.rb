class BankEntry < ActiveRecord::Base

	include HasParsedDate

	monetize :amount_cents, allow_nil: true

	has_many :accounting_entries, dependent: :destroy

end
