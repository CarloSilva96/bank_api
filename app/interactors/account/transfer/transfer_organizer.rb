module Account
  module Transfer
    class TransferOrganizer
      include Interactor::Organizer
      organize AccountTo, CreateTransferSent, ValidateTransferSent,
               CreateTransferReceived, SaveTransferSent, SaveTransferReceived
    end
  end
end