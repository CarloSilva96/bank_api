FactoryBot.define do
  factory 'new_account', class: 'Bank::Model::Account' do
    association :client, factory: 'new_client'
  end
end