# frozen_string_literal: true

module Bank
  module Model
    class Account < ApplicationRecord
      self.table_name = 'bank.accounts'

      enum status: {active: 0, closed: 1}, _prefix: :status, _default: :active

      include Bank::Concerns::Account::Associations
      include Bank::Concerns::Account::Validations
      include Bank::Concerns::Account::Methods
      include Bank::Concerns::Account::Callbacks
      include Bank::Concerns::Account::Scopes
    end
  end
end
