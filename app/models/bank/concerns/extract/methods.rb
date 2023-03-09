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
        end
      end
    end
  end
end
