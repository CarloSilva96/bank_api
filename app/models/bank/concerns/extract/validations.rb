# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Validations
        extend ActiveSupport::Concern

        included do
          validates :operation_type, :value, :date, presence: true
          validates :depositing_name, length: { minimum: 3 }, if: :operation_type_deposit?
          validates :depositing_cpf, length: { is: 11 }, if: :operation_type_deposit?
          validates :acc_transfer_agency, length: { is: 4 }, if: :operation_type_transfer_sent?
          validates :acc_transfer_number, length: { is: 8 }, if: :operation_type_transfer_sent?
          validates :fee_transfer, numericality: { greater_than: 0 }, if: :operation_type_transfer_sent?
        end

        private

        def operation_type_deposit?
          self.operation_type.eql?('deposit')
        end

        def operation_type_transfer_sent?
          self.operation_type.eql?('transfer_sent')
        end

      end
    end
  end
end
