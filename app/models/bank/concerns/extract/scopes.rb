# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Scopes
        extend ActiveSupport::Concern
        included do

          scope :by_start_date, lambda { |start_date|
            if start_date.present?
              where('date::date >= ?', start_date.to_date)
            end
          }

          scope :by_end_date, lambda { |end_date|
            if end_date.present?
              where('date::date <= ?', end_date.to_date)
            end
          }
        end
      end
    end
  end
end
