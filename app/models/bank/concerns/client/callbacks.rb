# frozen_string_literal: true
module Bank
  module Concerns
    module Client
      module Callbacks
        extend ActiveSupport::Concern

        included do
          before_validation :clean_cpf
          before_save :encrypt_password
        end

        private

        def clean_cpf
          self.cpf = cpf.gsub(/[^0-9]/, '') if cpf.present?
        end

        def encrypt_password
          self.password = BCrypt::Password.create(self.password)
        end

      end
    end
  end
end
