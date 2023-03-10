module Account
  module Deposit
    class DepositOrganizer
      include Interactor::Organizer
      organize CreateDeposit, AccountTo, InsertDeposit
    end
  end
end