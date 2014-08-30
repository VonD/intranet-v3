class CreateBankEntries < ActiveRecord::Migration
  def change
    create_table :bank_entries do |t|
      t.money :amount, currency: { present: false }, amount: { null: true, default: nil }
      t.date :date
      t.string :reference

      t.timestamps
    end
  end
end
