# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Validations
        extend ActiveSupport::Concern

        included do
          validates :type, :value, :date, presence: true
          validates :depositing_name, length: { minimum: 3 }
          validates :depositing_cpf, length: { is: 11 }
          validates :transfer_agency, length: { is: 4 }
          validates :transfer_account, length: { is: 6 }
        end

      end
    end
  end
end
