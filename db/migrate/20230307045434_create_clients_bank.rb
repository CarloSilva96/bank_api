class CreateClientsBank < ActiveRecord::Migration[7.0]
  def up
    create_table 'bank.clients' do |t|
      t.string :name, null: false
      t.string :last_name, null: false
      t.string :cpf, null: false, unique: true, limit: 11
      t.date :date_of_birth, null: false
      t.string :password, null: false
      t.timestamps
    end
  end

  def down
    drop_table 'bank.clients'
  end
end
