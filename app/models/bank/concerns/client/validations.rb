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
          validates :cpf, uniqueness: true, length: { is: 11 }
        end

      end
    end
  end
end
