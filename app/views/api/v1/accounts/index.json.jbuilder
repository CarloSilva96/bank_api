json.total_results @accounts.total_count
json.results @accounts do |account|
  json.call(account, :id, :agency, :number, :status)
  json.client do
    json.call(account.client, :id, :name, :last_name, :cpf)
  end
end
