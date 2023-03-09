
module Account
  module Deposit
    class InsertDeposit
      include Interactor

      def call
        context.account.balance = context.account.balance + context.deposit.value
        context.deposit.delete_attributes
        extract = Bank::Model::Extract.new(context.deposit.instance_values.compact_blank)
        extract.create_operation(Time.now, Bank::Model::Extract.operation_types[:deposit])
        context.voucher = extract
        context.account.extracts << extract
        context.fail!(status: 422) unless context.account.save
      end
    end
  end
end



