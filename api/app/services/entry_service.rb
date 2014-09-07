module EntryService

	def save
		validate && process && persist
	end

private

	def group_is_active?
		return true if @group.nil?
		valid = entries.map do |entry|
			invalid = entry.date.present? && @group.is_inactive_on?(entry.date)
			entry.errors.add(:date, :group_is_inactive_on_this_date) if invalid
			!invalid
		end
		valid.all?
	end

	def process
		true
	end

end
