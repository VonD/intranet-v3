class AddGroupIdToAccountingEntries < ActiveRecord::Migration
  def change
    add_column :accounting_entries, :group_id, :integer
  end
end
