module Account
  class AccountTo
    include Interactor
    include Interactor::Contracts

    expects do
      required(:agency).filled
      required(:account_number)
    end

    on_breach do |breaches|
      message = []
      breaches.each do |breach|
        message << breach.messages
      end
      context.fail!(status: 422, message: message.join(', '))
    end

    def call
      context.account_received = Bank::Model::Account
                          .by_agency_and_number(context.agency, context.account_number)
                          .by_status(Bank::Model::Account.statuses[:active])
                          .first
      context.fail!(status: 422, message: 'Account not exist or closed.') if context.account_received.nil?
    end
  end
end