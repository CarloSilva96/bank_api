class CreateAccountsBank < ActiveRecord::Migration[7.0]
  def up
    execute('CREATE SCHEMA IF NOT EXISTS bank')
    create_table 'bank.accounts' do |t|
      t.integer :agency, null: false
      t.integer :number, null: false, unique: true
      t.decimal :balance, precision: 16, scale: 2, null: false
      t.timestamps
    end

  end

  def down
    drop_table 'bank.accounts'
    execute('DROP SCHEMA bank CASCADE ')
  end
end
