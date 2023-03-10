FactoryBot.define do
  factory 'new_extract_deposit', class: 'Bank::Model::Extract' do
    operation_type { Bank::Model::Extract.operation_types[:deposit] }
    value { 200.00 }
    depositing_name { Faker::Name.last_name }
    depositing_cpf { Faker::CPF.number }
    date { Faker::Date.between(from: '2020-01-01', to: '2023-01-01') }
    association :account, factory: 'new_account'
  end
end