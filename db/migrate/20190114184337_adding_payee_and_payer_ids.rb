class AddingPayeeAndPayerIds < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :payee_id, :integer
    rename_column :transactions, :profile_id, :payer_id
    rename_column :profiles, :raters_quontity, :raters_quantity
  end
end
