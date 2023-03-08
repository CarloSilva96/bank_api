# frozen_string_literal: true

module Bank
  module Model
    class Extract < ApplicationRecord
      self.table_name = 'bank.extracts'

      enum operation_type: { deposit: 0, with_draw: 1, transfer_sent: 2, transfer_received: 3 }, _prefix: :operation_type

      include Bank::Concerns::Extract::Associations
      include Bank::Concerns::Extract::Validations
      include Bank::Concerns::Extract::Methods
      include Bank::Concerns::Extract::Callbacks
      include Bank::Concerns::Extract::Scopes
    end
  end
end
