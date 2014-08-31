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

end
