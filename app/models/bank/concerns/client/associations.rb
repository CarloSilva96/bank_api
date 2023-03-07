# frozen_string_literal: true

module Bank
  module Concerns
    module Client
      module Associations
        extend ActiveSupport::Concern
        included do
          belongs_to :account, class_name: 'Bank::Model::Account'
        end
      end
    end
  end
end
