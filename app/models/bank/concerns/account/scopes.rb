# frozen_string_literal: true

module Bank
  module Concerns
    module Account
      module Scopes
        extend ActiveSupport::Concern
        included do
          scope :by_agency_and_number, lambda { |agency, number|
            if agency.present? && number.present?
              where('agency = ? AND number = ?', agency, number)
            end
          }

          scope :by_agency, lambda { |agency|
            where('agency = ?', agency) if agency.present?
          }

          scope :by_number, lambda { |number|
            where('number = ?', number) if number.present?
          }
        end
      end
    end
  end
end
