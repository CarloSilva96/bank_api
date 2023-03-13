# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Validations
        extend ActiveSupport::Concern

        included do
          validates :operation_type, :value, :date, presence: true
          validates :value, numericality: { greater_than: 0 }
          validates :depositing_name, length: { minimum: 3 }, if: :operation_type_deposit?
          validates :acc_transfer_agency, length: { is: 4 }, if: :operation_type_transfer_sent?
          validates :acc_transfer_number, length: { is: 8 }, if: :operation_type_transfer_sent?
          validates :fee_transfer, numericality: { greater_than: 0 }, if: :operation_type_transfer_sent?
          validate :valid_depositing_cpf, if: :operation_type_deposit?
        end

        private

        def operation_type_deposit?
          self.operation_type.eql?(Bank::Model::Extract.operation_types[:deposit])
        end

        def operation_type_transfer_received?
          self.operation_type.eql?(Bank::Model::Extract.operation_types[:transfer_received])
        end

        def operation_type_transfer_sent?
          self.operation_type.eql?(Bank::Model::Extract.operation_types[:transfer_sent])
        end

        def valid_depositing_cpf
          errors.add(:depositing_cpf, 'depositing_cpf invalid') unless CPF.valid?(self.depositing_cpf)
        end

      end
    end
  end
end
