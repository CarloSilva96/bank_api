# frozen_string_literal: true

module Bank
  module Concerns
    module Account
      module Associations
        extend ActiveSupport::Concern
        included do
          has_many :extracts, class_name: 'Bank::Model::Extract'

          belongs_to :client, class_name: 'Bank::Model::Client',
                     foreign_key: :client_id, inverse_of: :account

          accepts_nested_attributes_for :client
        end
      end
    end
  end
end
