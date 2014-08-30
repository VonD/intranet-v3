class BankEntry < ActiveRecord::Base

	monetize :amount_cents, allow_nil: true

end
