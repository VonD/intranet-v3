class Group < ActiveRecord::Base

	validates_presence_of :name

	scope :real, -> { where(is_test: true) }
	scope :currently_active, -> { where('is_active_from >= ?', Date.today).where('is_active_to IS NULL OR is_active_to <= ?', Date.today) }

end
