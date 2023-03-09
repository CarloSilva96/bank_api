module Account
  module Deposit
    class DepositOrganizer
      include Interactor::Organizer
      organize CreateDeposit, AccountToDeposit, InsertDeposit
    end
  end
end