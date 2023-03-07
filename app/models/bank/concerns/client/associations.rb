# frozen_string_literal: true

module Bank
  module Concerns
    module Client
      module Associations
        extend ActiveSupport::Concern
        included do
          has_one :account, class_name: 'Bank::Model::Account',
                  inverse_of: :client
        end
      end
    end
  end
end
