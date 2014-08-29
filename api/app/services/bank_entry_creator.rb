class BankEntryCreator

	attr_accessor :bank_entry, :attributes

	def initialize attributes
		@attributes = attributes
		@bank_entry = BankEntry.new
	end

	def save
		validate && persist
	end

private

	def validate
		bank_entry.amount = attributes[:amount].to_money if attributes[:amount]
		bank_entry.date = attributes[:date] if attributes[:date]
		bank_entry.reference = attributes[:reference] if attributes[:reference]
		true
	end

	def persist
		bank_entry.save
	end

end
