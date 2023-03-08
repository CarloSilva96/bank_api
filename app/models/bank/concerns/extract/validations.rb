# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Validations
        extend ActiveSupport::Concern

        included do
          validates :operation_type, :value, :date, presence: true
          validates :depositing_name, length: { minimum: 3 } unless @depositing_name.nil?
          validates :depositing_cpf, length: { is: 11 } unless @depositing_cpf.nil?
          validates :transfer_agency, length: { is: 4 } unless @transfer_agency.nil?
          validates :transfer_account, length: { is: 6 } unless @transfer_account.nil?
        end

      end
    end
  end
end
