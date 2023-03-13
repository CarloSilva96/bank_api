
module Account
  module Deposit
    class MakeDeposit
      include Interactor
      def call
        deposit_extract = create_extract_deposit
        context.account_received.balance += deposit_extract.value
        context.fail!(status: 422, message: context.account_received.errors) unless context.account_received.save
        context.voucher = deposit_extract
      end

      private
      def create_extract_deposit
        context.deposit_params[:operation_type] = Bank::Model::Extract.operation_types[:deposit]
        extract_deposit = Bank::Model::Extract.factory_extract(context.deposit_params)
        extract_deposit.account = context.account_received
        context.fail!(status: 422, message: extract_deposit.errors) if extract_deposit.invalid?
        extract_deposit
      end

    end
  end
end



