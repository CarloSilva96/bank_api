# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bank::Model::Account, type: :model do
  describe 'Associations' do
    it { should have_many(:extracts).class_name('Bank::Model::Extract') }
    it { should belong_to(:client).class_name('Bank::Model::Client').with_foreign_key(:client_id) }
  end

  describe 'Callbacks' do
    describe 'gerar dados conta:' do
      it 'gera uma conta com dados válidos e cliente' do
        account = create(:new_client)
        expect(account.save).to be_truthy
      end
    end
  end

  describe 'Scopes' do
    before(:each) do
      @accounts = []
      3.times do
        @accounts << FactoryBot.create(:new_account)
      end
      2.times do
        @accounts << FactoryBot.create(:new_account, status: Bank::Model::Account.statuses[:closed])
      end
    end

    describe 'by_agency_and_number' do
      it 'retorna uma conta por meio da agencia e numero' do
        account = Bank::Model::Account.by_agency_and_number(@accounts.first&.agency, @accounts.first&.number)
        expect(account.length).to eq(1)
        expect(account.first&.id).to eq(@accounts.first&.id)
      end
    end

    describe 'by_status' do
      it 'retorna uma conta(s) por meio do status active' do
        accounts = Bank::Model::Account.by_status(Bank::Model::Account.statuses[:active])
        expect(accounts.length).to eq(3)
      end

      it 'retorna conta(s) por meio do status closed' do
        accounts = Bank::Model::Account.by_status(Bank::Model::Account.statuses[:closed])
        expect(accounts.length).to eq(2)
      end
    end

    describe 'by_agency' do
      it 'retorna conta(s) por meio da agencia' do
        account = FactoryBot.create(:new_account)
        account.agency = @accounts.first&.agency
        account.save
        accounts = Bank::Model::Account.by_agency(@accounts.first&.agency)
        expect(accounts.length).to be >= 2
      end
    end

    describe 'by_number' do
      it 'retorna uma conta(s) por meio do numero' do
        account = FactoryBot.create(:new_account)
        account.number = @accounts.first&.number
        account.save
        accounts = Bank::Model::Account.by_number(@accounts.first&.number)
        expect(accounts.length).to be >= 2
      end
    end
  end
end
