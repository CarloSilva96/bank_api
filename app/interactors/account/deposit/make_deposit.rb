
module Account
  module Deposit
    class MakeDeposit
      include Interactor
      def call
        deposit_extract = create_extract_deposit
        context.voucher = deposit_extract
        context.account_received.balance += deposit_extract.value
        context.fail!(status: 422, message: deposit_extract.errors) unless context.account_received.save
      end

      private
      def create_extract_deposit
        context.deposit_params[:operation_type] = 'deposit'
        deposit_extract = Bank::Model::Extract.factory_extract(context.deposit_params)
        context.account_received.extracts << deposit_extract
        context.fail!(status: 422, message: deposit_extract.errors) if deposit_extract.invalid?
        deposit_extract
      end

    end
  end
end



