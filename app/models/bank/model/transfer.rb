# frozen_string_literal: true

module Bank
  module Model
    class Transfer
      include ActiveModel::Model

      validates :value, :acc_transfer_agency, :acc_transfer_number, presence: true
      validates :value, numericality: true
      validates :acc_transfer_agency, length: { is: 4 }, numericality: { only_integer: true }
      validates :acc_transfer_number, length: { is: 8 }, numericality: { only_integer: true }

      attr_accessor :value, :acc_transfer_agency, :acc_transfer_number, :fee_transfer, :additional

    end
  end
end
