module HasParsedDates
	extend ActiveSupport::Concern

	included do

		columns.select do |column|
			column.type == :date && column.name != 'created_at' && column.name != 'updated_at'
		end.map(&:name).each do |attr|
			define_method "#{attr}=" do |expression|
				begin
					return write_attribute(attr, nil) if expression.blank?
					parsed_date = DateParser.parse(expression)
					instance_variable_set "@had_error_on_parsed_#{attr}", false
					write_attribute attr, parsed_date
				rescue ArgumentError
					instance_variable_set "@had_error_on_parsed_#{attr}", true
				end
			end
			validate do
				if instance_variable_get "@had_error_on_parsed_#{attr}"
					errors.add attr, :invalid
				end
			end
		end

	end

end
