module Account
  module Deposit
    class DepositOrganizer
      include Interactor::Organizer
      organize AccountTo, MakeDeposit
    end
  end
end