# frozen_string_literal: true

module Bank
  module Model
    class Extract < ApplicationRecord
      self.table_name = 'bank.extracts'

      enum operation_type: { deposit: 'deposit', with_draw: 'with_draw', transfer_sent: 'transfer_sent', transfer_received: 'transfer_received' }, _prefix: :operation_type

      include Bank::Concerns::Extract::Associations
      include Bank::Concerns::Extract::Validations
      include Bank::Concerns::Extract::Methods
      include Bank::Concerns::Extract::Callbacks
      include Bank::Concerns::Extract::Scopes
    end
  end
end
