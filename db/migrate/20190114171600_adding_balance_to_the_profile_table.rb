class AddingBalanceToTheProfileTable < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :balance, :float
  end
end
