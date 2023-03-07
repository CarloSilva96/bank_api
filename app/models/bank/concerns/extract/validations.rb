# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Validations
        extend ActiveSupport::Concern

        included do
          validates :agency, :number, :balance, presence: true
          validates :agency, length: {is: 4}
          validates :number, uniqueness: true, length: { is: 6 }
          validates :balance, numericality: { greater_than_or_equal_to: 0 }
        end

      end
    end
  end
end
