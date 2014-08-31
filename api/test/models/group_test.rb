require 'test_helper'

class GroupTest < ActiveSupport::TestCase

	test "it requires a name on create" do
		group = Group.new
		group.valid?
		assert group.errors.include?(:name)
	end

	test "it requires a name on update" do
		group = groups(:one)
		group.name = nil
		refute group.save
		assert group.errors.include?(:name)
	end

	test "is_test defaults to false" do
		group = Group.new
		assert_equal false, group.is_test
	end

	test "it allows empty dates on create" do
		group = Group.new
		group.valid?
		refute group.errors.include? :is_active_from
		refute group.errors.include? :is_active_to
		group.is_active_from = Date.today
		group.is_active_from = nil
		group.is_active_to = Date.today
		group.is_active_to = nil
		assert_nil group.is_active_from
		assert_nil group.is_active_to
	end

	test "it adds error on unparsable dates" do
		group = Group.new(is_active_from: "2014-02-31", is_active_to: "2014-02-33")
		group.valid?
		assert group.errors.include? :is_active_from
		assert group.errors.include? :is_active_to
	end
	
	test "it correcly cleans/adds dates errors" do
		group = Group.new
		group.valid?
		refute group.errors.include? :is_active_from
		group.is_active_from = "2014-02-31"
		group.valid?
		assert group.errors.include? :is_active_from
		group.is_active_from = "2014-02-02"
		group.valid?
		refute group.errors.include? :is_active_from
	end

end
