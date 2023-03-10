module Account
  module Transfer
    class CreateTransfer
      include Interactor
      include Interactor::Contracts

      expects do
        required(:transfer_params).filled
        required(:source_account).filled
      end

      on_breach do |breaches|
        message = []
        breaches.each do |breach|
          message << breach.messages
        end
        context.fail!(message: message.join(', '))
      end

      def call
        context.transfer = Bank::Model::Transfer.new(context.transfer_params)
        if context.transfer.invalid?
          context.fail!(status: 422, message: context.transfer.errors.messages)
        else
          context.agency = context.transfer.acc_transfer_agency
          context.account_number = context.transfer.acc_transfer_number
        end
      end
    end
  end
end