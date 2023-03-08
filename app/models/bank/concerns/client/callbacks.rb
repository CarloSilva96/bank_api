# frozen_string_literal: true
module Bank
  module Concerns
    module Client
      module Callbacks
        extend ActiveSupport::Concern

        included do
          before_validation :clean_attributes
          before_save :encrypt_password
        end

        private
        def clean_attributes
          self.cpf = clean_attribute(self.cpf)
        end

        def clean_attribute(attribute)
          attribute.present? ? attribute.gsub(/[^0-9]/, '') : nil
        end

        def encrypt_password
          self.password = BCrypt::Password.create(self.password)
        end

      end
    end
  end
end
