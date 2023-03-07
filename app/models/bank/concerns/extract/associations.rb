# frozen_string_literal: true

module Bank
  module Concerns
    module Extract
      module Associations
        extend ActiveSupport::Concern
        included do
          belongs_to :account, class_name: 'Bank::Model::Account',
                     foreign_key: :account_id, inverse_of: :extracts
        end
      end
    end
  end
end
