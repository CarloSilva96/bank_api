# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Methods
        extend ActiveSupport::Concern

        included do
          def create_operation(date, operation)
            self.operation_type = operation
            self.date = date
          end
          def self.factory_extract(attributes = {})
            extract = extract_specify(attributes)
            if extract.present?
              extract[:date] = Time.now
              extract[:value] = attributes[:value]
              extract[:operation_type] = attributes[:operation_type]
              Bank::Model::Extract.new(extract)
            else
              Bank::Model::Extract.new
            end
          end
          class << self
            def extract_specify(attributes = {})
              extract = nil
              if attributes[:operation_type].eql?('deposit')
                extract = extract_deposit(attributes)
              elsif attributes[:operation_type].eql?('transfer_sent')
                extract = extract_transfer_sent(attributes)
              end
              extract
            end
            def extract_deposit(attributes)
              {
                depositing_name: attributes[:depositing_name],
                depositing_cpf: attributes[:depositing_cpf]
              }
            end
            def extract_transfer_sent(attributes)
              {
                acc_transfer_agency: attributes[:depositing_name],
                acc_transfer_number: attributes[:depositing_cpf],
                fee_transfer: attributes[:fee_transfer],
                additional: attributes[:additional]
              }
            end

          end

        end
      end
    end
  end
end
