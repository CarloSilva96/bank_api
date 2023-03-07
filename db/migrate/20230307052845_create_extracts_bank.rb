class CreateExtractsBank < ActiveRecord::Migration[7.0]
  def up
    create_table 'bank.extracts' do |t|
      t.string :type, null: false
      t.decimal :value, precision: 16, scale: 2, null: false
      t.date :date, null: false
      t.string :depositing_name
      t.string :depositing_cpf, limit: 11
      t.integer :transfer_agency, limit: 4
      t.integer :transfer_account, limit: 6
      t.references :account, null: false, foreign_key: { to_table: 'bank.accounts' }, index: { name: 'extract_account_fk' }
      t.timestamps
    end

  end

  def down
    drop_table 'bank.extracts'
  end
end
