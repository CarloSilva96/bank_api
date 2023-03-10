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
      context.fail!(message: message.join(', '))
    end

    def call
      validate_withdraw
      extract_withdraw = create_extract_withdraw
      context.voucher = extract_withdraw
      context.account.balance -= extract_withdraw.value
      context.account.extracts << extract_withdraw
      context.fail!(status: 422) unless context.account.save
    end

    private

    def validate_withdraw
      context.fail!(status: 422, message: 'impossible to withdraw from closed account.') if context.account.status.eql?('closed')
      context.fail!(status: 422, message: 'balance insufficient.') if context.account.balance - context.withdraw < 0
    end

    def create_extract_withdraw
      Bank::Model::Extract.new(value: context.withdraw, date: Time.zone.now,
                               operation_type: Bank::Model::Extract.operation_types[:withdraw])
    end

  end
end