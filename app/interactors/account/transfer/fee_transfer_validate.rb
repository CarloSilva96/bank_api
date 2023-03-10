
module Account
  module Transfer
    class FeeTransferValidate
      include Interactor

      FEE_SCHEDULE_WEEK = 5
      FEE_OTHER = 7
      VALUE_ADDITIONAL = 10
      BASE_ADDITIONAL = 1000

      private_constant :FEE_SCHEDULE_WEEK
      private_constant :FEE_OTHER
      private_constant :VALUE_ADDITIONAL
      private_constant :BASE_ADDITIONAL

      def call
        set_fee_transfer
        validate_balance_and_update
      end

      private

      def validate_balance_and_update
        balance_update = context.source_account.balance - context.transfer.value + context.transfer.fee_transfer
        if balance_update < 0
          context.fail!(status: 422, message: 'Balance insufficient.')
        end
      end

      def set_fee_transfer
        day_transfer = Time.zone.now
        is_schedule_week = day_transfer.between?(Time.zone.parse("09:00"), Time.zone.parse("18:00"))

        if !day_transfer.on_weekend? && is_schedule_week
          context.transfer.fee_transfer = FEE_SCHEDULE_WEEK
        else
          context.transfer.fee_transfer = FEE_OTHER
        end
        context.transfer.additional = VALUE_ADDITIONAL if context.transfer.value > BASE_ADDITIONAL
      end

    end
  end
end


