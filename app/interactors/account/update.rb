module Account
  class Update
    include Interactor
    include Interactor::Contracts

    expects do
      required(:account_params).filled
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
      context.account.assign_attributes(context.account_params)
      context.fail!(status: 422) unless context.account.save
    end

  end
end