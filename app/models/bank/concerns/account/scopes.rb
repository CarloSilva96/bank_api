# frozen_string_literal: true

module Bank
  module Concerns
    module Account
      module Scopes
        extend ActiveSupport::Concern
        included do
          scope :by_agency_and_number, lambda { |agency, number|
            if agency.present? && number.present?
              where('agency = ? AND number = ?', agency, number).first
            end
          }
        end
      end
    end
  end
end
