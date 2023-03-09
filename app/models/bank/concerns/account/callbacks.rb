# frozen_string_literal: true
module Bank
  module Concerns
    module Account
      module Callbacks
        extend ActiveSupport::Concern

        included do
          before_create :generate_account
        end

        private
        def generate_account
          generate_agency
          generate_number
          self.balance = 0
        end
        def generate_agency
          self.agency = Faker::Number.number(digits: 4)
        end
        def generate_number
          exists_account = true
          while exists_account
            number = Faker::Number.number(digits: 8)
            account = Bank::Model::Account.by_agency_and_number(self.agency, number).first
            if account.nil?
              self.number = number
              exists_account = false
            end
          end
        end

      end
    end
  end
end
