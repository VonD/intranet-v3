class AddGroupIdToBankEntries < ActiveRecord::Migration
  def change
    add_column :bank_entries, :group_id, :integer
  end
end
