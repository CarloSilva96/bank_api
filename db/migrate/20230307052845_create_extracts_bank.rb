class CreateExtractsBank < ActiveRecord::Migration[7.0]
  def up
    create_table 'bank.extracts' do |t|
      t.string :operation_type, null: false
      t.decimal :value, precision: 16, scale: 2, null: false
      t.decimal :fee_transfer, precision: 5, scale: 2
      t.decimal :additional, precision: 5, scale: 2
      t.timestamp :date, null: false
      t.string :depositing_name
      t.string :depositing_cpf, limit: 11
      t.integer :acc_transfer_agency, limit: 4
      t.integer :acc_transfer_number, limit: 8
      t.timestamps
    end

  end

  def down
    drop_table 'bank.extracts'
  end
end
