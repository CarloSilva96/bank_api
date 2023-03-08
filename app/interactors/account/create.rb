module Account
  class Create
    include Interactor
    include Interactor::Contracts

    expects do
      required(:account_params).filled
    end

    on_breach do |breaches|
      message = []
      breaches.each do |breach|
        message << breach.messages
      end
      context.fail!(message: message.join(', '))
    end

    def call
      context.account = Bank::Model::Account.new(context.account_params)
      context.fail!(status: 422) unless context.account.save
    end

  end
end