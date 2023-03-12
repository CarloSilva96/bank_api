module Account
  module Transfer
    class ValidateTransferSent
      include Interactor

      def call
        context.fail!(status: 422, message: 'Balance insufficient.') if is_available_balance?
        context.fail!(status: 422, message: 'It is not allowed to transfer to yourself.') if acc_sent_different_received?
      end

      private

      def is_available_balance?
        balance_update = context.source_account.balance - context.extract_transfer_sent.value +
          context.extract_transfer_sent.fee_transfer
        balance_update += context.extract_transfer_sent.additional if context.extract_transfer_sent.additional.present?
        balance_update < 0
      end

      def acc_sent_different_received?
        context.source_account.id.eql?(context.account_received.id)
      end

    end
  end
end



