json.call(@account, :id, :agency, :number, :balance)
json.client do
  json.call(@account.client, :id, :name, :last_name, :cpf, :email, :date_of_birth)
end