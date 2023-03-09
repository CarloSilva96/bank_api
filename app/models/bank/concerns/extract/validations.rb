# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Validations
        extend ActiveSupport::Concern

        included do
          validates :operation_type, :value, :date, presence: true
          validates :depositing_name, length: { minimum: 3 } if :exist_depositing_name?
          validates :depositing_cpf, length: { is: 11 } unless :exist_depositing_cpf?
          validates :acc_transfer_agency, length: { is: 4 } unless :exist_acc_transfer_agency?
          validates :acc_transfer_number, length: { is: 8 } unless :exist_acc_transfer_number?
        end

        private

        def exist_depositing_name?
          self.depositing_name&.nil?
        end

        def exist_depositing_cpf?
          self.depositing_cpf&.nil?
        end
        def exist_acc_transfer_agency?
          self.acc_transfer_agency&.nil?
        end
        def exist_acc_transfer_number?
          self.acc_transfer_number&.nil?
        end

      end
    end
  end
end
