class Group < ActiveRecord::Base

	include HasParsedDates

	validates_presence_of :name
	validate :activity_date_sequence

	scope :real, -> { where(is_test: true) }
	scope :currently_active, -> { where('is_active_from >= ?', Date.today).where('is_active_to IS NULL OR is_active_to <= ?', Date.today) }

	has_many :bank_entries

	def is_active_on? date
		return is_active_from.present? && is_active_from <= date && (is_active_to.nil? || is_active_to >= date)
	end

private

	def activity_date_sequence
		if is_active_from.nil? && is_active_to.present?
			errors.add :is_active_from, :invalid
			false
		else
			return true if is_active_from.nil? || is_active_to.nil? || is_active_from <= is_active_to
			errors.add :is_active_to, greater_than_or_equal_to: is_active_from
			false
		end
	end

end
