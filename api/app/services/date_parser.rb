class DateParser

	attr_reader :date

	def self.parse expression
		return expression if expression.is_a?(Date)
		parser = self.new.instance_eval do
			@original_expression = expression
			@expression = @original_expression.to_s.strip.downcase
			resolve!
		end
		parser.date
	end

private

	def resolve!
		tap do
			@date = Date.parse(@expression)
		end
	end

end
