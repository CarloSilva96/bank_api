module Account
  module Deposit
    class AccountToDeposit
      include Interactor

      def call
        context.account = Bank::Model::Account
                            .by_agency_and_number(context.deposit.account_agency, context.deposit.account_number)
                            .by_status(Bank::Model::Account.statuses[:active])
                            .first
        context.fail!(status: 422, message: 'Account not exist or closed.') if context.account.nil?
      end
    end
  end
end