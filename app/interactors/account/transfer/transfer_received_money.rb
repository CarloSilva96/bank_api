module Account
  module Transfer
    class TransferReceivedMoney
      include Interactor

      def call
        extract_transfer_received = create_extract_trans_received
        context.account_received.balance += extract_transfer_received.value
        context.account_received.extracts << extract_transfer_received
        context.fail!(status: 422, message: 'Error in transfers') unless context.account_received.save
      end

      private

      def create_extract_trans_received
        extract_transfer_received = Bank::Model::Extract.new
        extract_transfer_received.acc_transfer_agency = context.source_account.agency
        extract_transfer_received.acc_transfer_number = context.source_account.number
        extract_transfer_received.fee_transfer = nil
        extract_transfer_received.value = context.transfer.value
        extract_transfer_received.create_operation(Time.now, Bank::Model::Extract.operation_types[:transfer_received])
        extract_transfer_received
      end

    end
  end
end