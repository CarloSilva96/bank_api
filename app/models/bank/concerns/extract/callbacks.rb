# frozen_string_literal: true
module Bank
  module Concerns
    module Extract
      module Callbacks
        extend ActiveSupport::Concern
        included do
          before_validation :clean_attributes
          before_save :to_negative_withdrawal
        end

        private
        def clean_attributes
          self.depositing_cpf = clean_attribute(self.depositing_cpf)
        end
        def clean_attribute(attribute)
          attribute.present? ? attribute.gsub(/[^0-9]/, '') : nil
        end

        def to_negative_withdrawal
          if self.operation_type.eql?(Bank::Model::Extract.operation_types[:withdraw]) || self.operation_type.eql?(Bank::Model::Extract.operation_types[:transfer_sent])
            self.value = self.value * -1
            self.fee_transfer = self.fee_transfer * -1 if self.fee_transfer.present?
            self.additional = self.additional * -1 if self.additional.present?
          end
        end

      end
    end
  end
end
