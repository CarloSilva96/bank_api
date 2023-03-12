module Account
  module Transfer
    class SaveTransferSent
      include Interactor

      def call
        context.source_account.balance -= context.extract_transfer_sent.value + context.extract_transfer_sent.fee_transfer
        context.source_account.balance -= context.extract_transfer_sent.additional if context.extract_transfer_sent.additional.present?
        context.fail!(status: 422, message: context.source_account.errors) unless context.source_account.save
        context.voucher = context.extract_transfer_sent
      end

    end
  end
end