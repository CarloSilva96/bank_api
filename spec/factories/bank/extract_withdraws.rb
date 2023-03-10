FactoryBot.define do
  factory 'new_extract_withdraw', class: 'Bank::Model::Extract' do
    operation_type { Bank::Model::Extract.operation_types[:withdraw] }
    value { 100.00 }
    date { Faker::Date.between(from: '2020-01-01', to: '2023-01-01') }
    association :account, factory: 'new_account'
  end
end