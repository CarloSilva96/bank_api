module Account
  class Close
    include Interactor
    include Interactor::Contracts

    expects do
      required(:account).filled
    end

    on_breach do |breaches|
      message = []
      breaches.each do |breach|
        message << breach.messages
      end
      context.fail!(message: message.join(', '))
    end

    def call
      context.account.status = Bank::Model::Account.statuses[:closed]
      context.fail!(status: 422) unless context.account.save
    end

  end
end