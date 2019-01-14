class RemovingUselessColumsFromTransactionTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :payee
    remove_column :transactions, :payer
  end
end
