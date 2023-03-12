module Account
  module Transfer
    class SaveTransferReceived
      include Interactor
      def call
        context.account_received.balance += context.extract_transfer_received.value
        context.fail!(status: 422, message: context.account_received.errors) unless context.account_received.save
      end

    end
  end
end