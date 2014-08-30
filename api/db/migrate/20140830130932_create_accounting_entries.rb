class CreateAccountingEntries < ActiveRecord::Migration
  def change
    create_table :accounting_entries do |t|
      t.integer :bank_entry_id
      t.date :date
      t.money :amount, currency: { present: false }

      t.timestamps
    end
  end
end
