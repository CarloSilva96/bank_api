class AddReferenceClientInAccount < ActiveRecord::Migration[7.0]
  def change
    add_reference 'bank.accounts', :client, null: false, foreign_key: { to_table: 'bank.clients' }, index: { name: 'clients_fk' }
  end
end
