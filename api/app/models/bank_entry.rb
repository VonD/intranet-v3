class BankEntry < ActiveRecord::Base

	include HasParsedDates

	monetize :amount_cents, allow_nil: true

	has_many :accounting_entries, dependent: :destroy
	belongs_to :group

	validates_presence_of :group

end
