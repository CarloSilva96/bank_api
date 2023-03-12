require 'rspec'

def valid_login
  account = generate_account
  token = ::Bank::Utils::JsonWebToken.encode(account_id: account.id)
  {
    id: account.id,
    token: token
  }
end

def generate_account
  account = FactoryBot.build(:new_account, balance: 0)
  account.client = FactoryBot.build(:new_client)
  account.save
  account
end
