# frozen_string_literal: true

module Bank
  module Model
    class Extract < ApplicationRecord
      self.table_name = 'bank.extracts'

      enum type: { 'DEPOSIT': 0, 'WITH_DRAW': 1, 'TRANSFER_SENT': 2, 'TRANSFER_RECEIVED': 4 }, _prefix: :type

      include Bank::Concerns::Extract::Associations
      include Bank::Concerns::Extract::Validations
      include Bank::Concerns::Extract::Methods
      include Bank::Concerns::Extract::Callbacks
      include Bank::Concerns::Extract::Scopes
    end
  end
end
