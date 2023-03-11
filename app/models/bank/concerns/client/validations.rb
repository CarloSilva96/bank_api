# frozen_string_literal: true

module Bank
  module Concerns
    module Client
      module Validations
        extend ActiveSupport::Concern

        included do
          validates :name, :last_name, :cpf, :date_of_birth, :email, presence: true
          validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
          validates :name, :last_name, length: { minimum: 3 }
          validates :cpf, uniqueness: true
          validate :valid_cpf
        end

        private

        def valid_cpf
          errors.add(:cpf, 'cpf invalid') unless CPF.valid?(self.cpf)
        end
      end
    end
  end
end
