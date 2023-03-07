class CreateAccountsBank < ActiveRecord::Migration[7.0]
  def up
    execute('CREATE SCHEMA IF NOT EXISTS bank')
    create_table 'bank.accounts' do |t|
      t.string :agency, null: false
      t.string :number, null: false
      t.references :client, null: false, foreign_key: { to_table: 'bank.clients' }, index: { name: 'clients_fk' }
      t.decimal :balance, precision: 16, scale: 2, null: false
      t.timestamps
    end

    # add_index 'gaia.beneficios', :nome, name: 'beneficios_nome_unique', unique: true
  end

  def down
    drop_table 'bank.accounts'
    execute('DROP SCHEMA bank')
  end
end
