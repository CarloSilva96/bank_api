
module Account
  module Deposit
    class InsertDeposit
      include Interactor

      def call
        context.account_received.balance = context.account_received.balance + context.deposit.value
        extract_deposit = create_extract_deposit
        context.voucher = extract_deposit
        context.account_received.extracts << extract_deposit
        context.fail!(status: 422) unless context.account_received.save
      end

      private

      def create_extract_deposit
        context.deposit.delete_attributes
        extract_deposit = Bank::Model::Extract.new(context.deposit.instance_values.compact_blank)
        extract_deposit.create_operation(Time.now, Bank::Model::Extract.operation_types[:deposit])
        extract_deposit
      end

    end
  end
end



