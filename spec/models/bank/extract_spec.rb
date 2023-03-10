# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bank::Model::Client, type: :model do

  describe 'Callbacks' do

  end

  describe 'Validations' do
    subject {
      create(:new_extract_deposit)
    }
    it { should validate_presence_of(:operation_type) }
    it { should validate_presence_of(:value) }
    it { should validate_presence_of(:date) }

    before(:each) do
      @accounts = []
      3.times do
        @accounts << FactoryBot.create(:new_account)
      end
    end

    describe 'validate_extract:' do
      describe 'extract deposit'  do
        context 'depositing name é nulo' do
          it 'não deixa salvar' do
            byebug
            extract_deposit = build(:new_extract_deposit, depositing_name: nil, account: @accounts.first )
            expect(extract_deposit.save).to be_falsey
          end
        end

        context 'depositing name tamanho invalido' do
          it 'não deixa salvar' do
            byebug
            extract_deposit = build(:new_extract_deposit, depositing_name: 'ca', account: @accounts.first )
            expect(extract_deposit.save).to be_falsey
          end
        end

        context 'depositing cpf é nulo' do
          it 'não deixa salvar' do
            extract_deposit = build(:new_extract_deposit, depositing_cpf: nil)
            expect(extract_deposit.save).to be_falsey
          end
        end

        context 'depositing cpf tamanho invalido' do
          it 'não deixa salvar' do
            extract_deposit = build(:new_extract_deposit, depositing_cpf: '1234')
            expect(extract_deposit.save).to be_falsey
          end
        end
      end

      describe 'extract transfer sent' do
        context 'transfer sent agency é nulo' do
          it 'não deixa salvar' do
            extract_transfer = build(:new_extract_transfer_sent, acc_transfer_agency: nil, account: @accounts.second )
            expect(extract_transfer.save).to be_falsey
          end
        end

        context 'transfer sent agency tamanho inválido' do
          it 'não deixa salvar' do
            extract_transfer = build(:new_extract_transfer_sent, acc_transfer_agency: 12, account: @accounts.second )
            expect(extract_transfer.save).to be_falsey
          end
        end

        context 'transfer sent number é nulo' do
          it 'não deixa salvar' do
            extract_transfer = build(:new_extract_transfer_sent, acc_transfer_number: nil)
            expect(extract_transfer.save).to be_falsey
          end
        end

        context 'transfer sent number tamanho invalido' do
          it 'não deixa salvar' do
            extract_transfer = build(:new_extract_transfer_sent, acc_transfer_number: 1234)
            expect(extract_transfer.save).to be_falsey
          end
        end
      end
    end

  end
end
