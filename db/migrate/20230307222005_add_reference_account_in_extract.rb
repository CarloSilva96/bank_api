class AddReferenceAccountInExtract < ActiveRecord::Migration[7.0]
  def change
    add_reference 'bank.extracts', :account, null: false, foreign_key: { to_table: 'bank.accounts' }, index: { name: 'extract_account_fk' }
  end
end
