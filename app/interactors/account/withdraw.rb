module Account
  class Withdraw
    include Interactor
    include Interactor::Contracts

    expects do
      required(:withdraw).filled
      required(:account).filled
    end

    on_breach do |breaches|
      message = []
      breaches.each do |breach|
        message << breach.messages
      end
      context.fail!(status: 422, message: message.join(', '))
    end

    def call
      extract_withdraw = create_extract_with_draw
      validate_withdraw(extract_withdraw)
      context.account.balance -= extract_withdraw.value
      context.fail!(status: 422, message: context.account.errors) unless context.account.save
      context.voucher = extract_withdraw
    end

    private

    def validate_withdraw(extract_withdraw)
      context.fail!(status: 422, message: 'impossible to withdraw from closed account.') if context.account.status.eql?('closed')
      context.fail!(status: 422, message: 'balance insufficient.') if context.account.balance - extract_withdraw.value < 0
    end

    def create_extract_with_draw
      extract_deposit = Bank::Model::Extract.factory_extract({ value: context.withdraw[:withdraw], operation_type: 'withdraw'} )
      extract_deposit.account = context.account
      context.fail!(status: 422, message: extract_deposit.errors) if extract_deposit.invalid?
      extract_deposit
    end

  end
end