FactoryBot.define do
  factory 'new_account', class: 'Bank::Model::Account' do
    agency { Faker::Number.number(digits: 4) }
    number { Faker::Number.number(digits: 6) }
    balance { 200.00 }
    association :client, factory: 'new_client'
  end
end