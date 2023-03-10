json.call(@voucher, :operation_type, :value, :date)
if @voucher.operation_type == 'deposit'
  json.call(@voucher, :depositing_name, :depositing_cpf)
  json.receiver do
    json.call(@voucher.account, :agency, :number)
    json.call(@voucher.account.client, :name)
  end
elsif @voucher.operation_type == 'transfer_received' || @voucher.operation_type == 'transfer_sent'
  json.call(@voucher, :acc_transfer_agency, :acc_transfer_number)
  json.fee_transfer @voucher.fee_transfer if @voucher.fee_transfer.present?
  json.additional @voucher.additional if @voucher.additional.present?
end