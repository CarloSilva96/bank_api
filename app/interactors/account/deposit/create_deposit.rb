module Account
  module Deposit
    class CreateDeposit
      include Interactor
      include Interactor::Contracts

      expects do
        required(:deposit_params).filled
      end

      on_breach do |breaches|
        message = []
        breaches.each do |breach|
          message << breach.messages
        end
        context.fail!(message: message.join(', '))
      end

      def call
        context.deposit = Bank::Model::Deposit.new(context.deposit_params)
        if context.deposit.invalid?
          context.fail!(status: 422, message: context.deposit.errors.messages)
        end
      end

    end
  end
end