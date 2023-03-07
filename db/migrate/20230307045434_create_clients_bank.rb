class CreateClientsBank < ActiveRecord::Migration[7.0]
  def up
    create_table 'bank.clients' do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :cpf, null: false
      t.date :date_of_birth, null: false
      t.string :password, null: false
      t.timestamps
    end

    # add_index 'gaia.beneficios', :nome, name: 'beneficios_nome_unique', unique: true
  end

  def down
    drop_table 'bank.clients'
  end
end
