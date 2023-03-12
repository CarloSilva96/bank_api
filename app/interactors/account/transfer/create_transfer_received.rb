module Account
  module Transfer
    class CreateTransferReceived
      include Interactor
      def call
        context.extract_transfer_received = create_extract_transf_received
      end

      private

      def create_extract_transf_received
        context.transfer_params[:operation_type] = 'transfer_received'
        context.transfer_params[:acc_transfer_agency] = context.source_account.agency
        context.transfer_params[:acc_transfer_number] = context.source_account.number
        extract_transfer_received = Bank::Model::Extract.factory_extract(context.transfer_params)
        extract_transfer_received.account = context.account_received
        context.fail!(status: 422, message: extract_transfer_received.errors) if extract_transfer_received.invalid?
        extract_transfer_received
      end

    end
  end
end