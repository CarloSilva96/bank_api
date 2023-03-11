# frozen_string_literal: true

module Bank
  module Model
    class Deposit
      include ActiveModel::Model

      validates :value, :depositing_name, :depositing_cpf, :account_agency, :account_number, presence: true
      validates :value, numericality: { greater_than: 0 }
      validates :depositing_name, length: { minimum: 3 }
      validates :account_agency, length: { is: 4 }, numericality: { only_integer: true }
      validates :account_number, length: { is: 8 }, numericality: { only_integer: true }
      validate :valid_depositing_cpf

      attr_accessor :value, :depositing_name, :depositing_cpf, :account_agency, :account_number

      def delete_attributes
        self.account_agency = nil
        self.account_number = nil
      end

      private
      def valid_depositing_cpf
        errors.add(:depositing_cpf, 'depositing_cpf invalid') unless CPF.valid?(self.depositing_cpf)
      end
    end
  end
end
