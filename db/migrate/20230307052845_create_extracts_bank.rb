class CreateExtractsBank < ActiveRecord::Migration[7.0]
  def up
    create_table 'bank.extracts' do |t|
      t.string :type, null: false
      t.decimal :value, precision: 16, scale: 2, null: false
      t.date :date, null: false
      t.references :account, null: false, foreign_key: { to_table: 'bank.accounts' }, index: { name: 'accounts_fk' }
      t.timestamps
    end

    # add_index 'gaia.beneficios', :nome, name: 'beneficios_nome_unique', unique: true
  end

  def down
    drop_table 'bank.extracts'
  end
end
