class CreateBankEntries < ActiveRecord::Migration
  def change
    create_table :bank_entries do |t|
      t.money :amount, currency: { present: false }
      t.date :date
      t.string :reference

      t.timestamps
    end
  end
end
