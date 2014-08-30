module HasParsedDate
	extend ActiveSupport::Concern

	def date= expression
		begin
			return write_attribute(:date, nil) if expression.blank?
			parsed_date = DateParser.parse(expression)
			@had_error_on_parsed_date = false
			write_attribute :date, parsed_date
		rescue ArgumentError
			@had_error_on_parsed_date = true
		end
	end

	included do
		validate do
			if @had_error_on_parsed_date
				errors.add :date, :invalid
			end
		end
	end

end
