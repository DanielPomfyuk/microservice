class CreatingTransactionTable < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :payee
      t.string :payer
      t.float :amount
      t.datetime :made_at
      t.column :currency, :integer, default: 0
    end
  end
end
