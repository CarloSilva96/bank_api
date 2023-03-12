module Account
  module Transfer
    class CreateTransferSent
      include Interactor
      include Interactor::Contracts

      FEE_SCHEDULE_WEEK = 5
      FEE_OTHER = 7
      VALUE_ADDITIONAL = 10
      BASE_ADDITIONAL = 1000

      private_constant :FEE_SCHEDULE_WEEK
      private_constant :FEE_OTHER
      private_constant :VALUE_ADDITIONAL
      private_constant :BASE_ADDITIONAL

      expects do
        required(:source_account).filled
        required(:transfer_params).filled
      end

      on_breach do |breaches|
        message = []
        breaches.each do |breach|
          message << breach.messages
        end
        context.fail!(status: 422, message: message.join(', '))
      end
      def call
        context.extract_transfer_sent = create_extract_transfer_sent
      end

      private

      def create_extract_transfer_sent
        context.transfer_params[:operation_type] = 'transfer_sent'
        extract_transfer_sent = Bank::Model::Extract.factory_extract(context.transfer_params)
        extract_transfer_sent.account = context.source_account
        fee_transfer_additional(extract_transfer_sent)
        context.fail!(status: 422, message: extract_transfer_sent.errors) if extract_transfer_sent.invalid?
        extract_transfer_sent
      end

      def fee_transfer_additional(ex_transfer_sent)
        day_transfer = Time.zone.now
        is_schedule_week = day_transfer.between?(Time.zone.parse("09:00"), Time.zone.parse("18:00"))
        if !day_transfer.on_weekend? && is_schedule_week
          ex_transfer_sent.fee_transfer = FEE_SCHEDULE_WEEK
        else
          ex_transfer_sent.fee_transfer = FEE_OTHER
        end
        ex_transfer_sent.additional = VALUE_ADDITIONAL if ex_transfer_sent.value > BASE_ADDITIONAL
      end

    end
  end
end