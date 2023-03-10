module Account
  class AccountTo
    include Interactor
    include Interactor::Contracts
    def call
      context.account_received = Bank::Model::Account
                          .by_agency_and_number(context.agency, context.account_number)
                          .by_status(Bank::Model::Account.statuses[:active])
                          .first
      context.fail!(status: 422, message: 'Account not exist or closed.') if context.account_received.nil?
    end
  end
end