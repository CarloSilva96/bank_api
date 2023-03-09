FactoryBot.define do
  factory 'new_deposit', class: 'Bank::Model::Deposit' do
    operation_type { Bank::Model::Extract.operation_types[:deposit] }
    value { 200.00 }
    depositing_name { Faker::Name.last_name }
    depositing_cpf { Faker::CPF.cpf }
    date { Faker::Date.between(from: '2020-01-01', to: '2023-01-01') }
  end
end