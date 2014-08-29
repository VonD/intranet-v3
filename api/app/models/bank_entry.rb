class BankEntry < ActiveRecord::Base

	monetize :amount_cents

end
