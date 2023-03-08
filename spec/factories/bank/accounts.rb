FactoryBot.define do
  factory 'new_account', class: 'Bank::Model::Account' do
    balance { 200.00 }
    association :client, factory: 'new_client'
  end
end