json.total_results @extracts.total_count
json.results @extracts do |extract|
  json.call(extract, :id, :operation_type, :value, :date)
  if extract.operation_type == Bank::Model::Extract.operation_types[:deposit]
    json.call(extract, :depositing_name, :depositing_cpf)
    json.receiver do
      json.call(extract.account, :agency, :number)
      json.call(extract.account.client, :name)
    end
  end
  if extract.operation_type == Bank::Model::Extract.operation_types[:transfer_received] || extract.operation_type == Bank::Model::Extract.operation_types[:transfer_sent]
    json.call(extract, :acc_transfer_agency, :acc_transfer_number)
    json.fee_transfer extract.fee_transfer if extract.fee_transfer.present?
    json.additional extract.additional if extract.additional.present?
  end
end

