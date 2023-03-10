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
        context 'depositing_name é nulo' do
          it 'não deixa salvar' do
            extract_deposit = build(:new_extract_deposit, depositing_name: nil, account: @accounts.first )
            expect(extract_deposit.save).to be_falsey
          end
        end

        context 'depositing_name tamanho invalido' do
          it 'não deixa salvar' do
            extract_deposit = build(:new_extract_deposit, depositing_name: 'ca', account: @accounts.first )
            expect(extract_deposit.save).to be_falsey
          end
        end

        context 'depositing_cpf é nulo' do
          it 'não deixa salvar' do
            extract_deposit = build(:new_extract_deposit, depositing_cpf: nil)
            expect(extract_deposit.save).to be_falsey
          end
        end

        context 'depositing_cpf tamanho invalido' do
          it 'não deixa salvar' do
            extract_deposit = build(:new_extract_deposit, depositing_cpf: '1234')
            expect(extract_deposit.save).to be_falsey
          end
        end
      end

      describe 'extract transfer sent' do
        context 'acc_transfer_agency é nulo' do
          it 'não deixa salvar' do
            extract_transfer_sent = build(:new_extract_transfer_sent, acc_transfer_agency: nil, account: @accounts.second )
            expect(extract_transfer_sent.save).to be_falsey
          end
        end

        context 'acc_transfer_agency tamanho inválido' do
          it 'não deixa salvar' do
            extract_transfer_sent = build(:new_extract_transfer_sent, acc_transfer_agency: 12, account: @accounts.second )
            expect(extract_transfer_sent.save).to be_falsey
          end
        end

        context 'acc_transfer_number é nulo' do
          it 'não deixa salvar' do
            extract_transfer_sent = build(:new_extract_transfer_sent, acc_transfer_number: nil)
            expect(extract_transfer_sent.save).to be_falsey
          end
        end

        context 'acc_transfer_number tamanho invalido' do
          it 'não deixa salvar' do
            extract_transfer_sent = build(:new_extract_transfer_sent, acc_transfer_number: 1234)
            expect(extract_transfer_sent.save).to be_falsey
          end
        end

        context 'fee_transfer menor ou igual a 0' do
          it 'não deixa salvar' do
            extract_transfer_sent = build(:new_extract_transfer_sent, fee_transfer: 0)
            expect(extract_transfer_sent.save).to be_falsey
          end
        end

      end
    end

  end
end
