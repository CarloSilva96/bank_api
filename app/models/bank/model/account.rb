# frozen_string_literal: true

module Bank
  module Model
    class Account < ApplicationRecord
      self.table_name = 'bank.accounts'

      include Bank::Concerns::Account::Associations
      include Bank::Concerns::Account::Validations
      include Bank::Concerns::Account::Methods
      include Bank::Concerns::Account::Callbacks
      include Bank::Concerns::Account::Scopes
    end
  end
end
