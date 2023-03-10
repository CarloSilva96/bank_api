module Account
  module Transfer
    class TransferOrganizer
      include Interactor::Organizer
      organize CreateTransfer, AccountTo, FeeTransferValidate,
               TransferSentMoney, TransferReceivedMoney
    end
  end
end