json.call(@account, :id, :agency, :number, :balance, :created_at, :updated_at)
json.client do
  json.call(@account.client, :id, :name, :last_name, :cpf, :email, :date_of_birth)
end