module Account
  module Transfer
    class TransferSentMoney
      include Interactor

      def call
        extract_transfer_sent = create_extract_transfer_sent
        context.voucher = extract_transfer_sent
        context.source_account.balance -= extract_transfer_sent.value + extract_transfer_sent.fee_transfer
        context.source_account.balance -= extract_transfer_sent.additional if extract_transfer_sent.additional.present?
        context.source_account.extracts << extract_transfer_sent
        context.fail!(status: 422) unless context.source_account.save
      end

      private

      def create_extract_transfer_sent
        extract_transfer_sent = Bank::Model::Extract.new(context.transfer.instance_values.compact_blank)
        extract_transfer_sent.create_operation(Time.now, Bank::Model::Extract.operation_types[:transfer_sent])
        extract_transfer_sent
      end

    end
  end
end