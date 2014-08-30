class BankEntry < ActiveRecord::Base

	include HasParsedDate

	monetize :amount_cents, allow_nil: true

end
