# frozen_string_literal: true

module Bank
  module Model
    class Account < ApplicationRecord
      self.table_name = 'bank.clients'

      include Bank::Concerns::Client::Associations
      include Bank::Concerns::Client::Validations
      include Bank::Concerns::Client::Methods
      include Bank::Concerns::Client::Callbacks
      include Bank::Concerns::Client::Scopes
    end
  end
end
