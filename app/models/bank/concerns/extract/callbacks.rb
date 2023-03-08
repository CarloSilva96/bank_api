# frozen_string_literal: true
module Bank
  module Concerns
    module Extract
      module Callbacks
        extend ActiveSupport::Concern
        included do
          before_validation :clean_attributes
        end

        private
        def clean_attributes
          self.depositing_cpf = clean_attribute(self.depositing_cpf)
          self.transfer_agency = clean_attribute(self.transfer_agency)
          self.transfer_account = clean_attribute(self.transfer_account)
        end
        def clean_attribute(attribute)
          attribute.present? ? attribute.gsub(/[^0-9]/, '') : nil
        end

      end
    end
  end
end
