# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bank::Model::Client, type: :model do

  describe 'Callbacks' do
    describe 'limpar depositing_cpf:' do
      it 'remove caracteres não numericos' do
        depositing_cpf = Faker::CPF.cpf
        extract_deposit = create(:new_extract_deposit, depositing_cpf: depositing_cpf)
        extract_deposit.save
        expect(extract_deposit.depositing_cpf).to eq(depositing_cpf.gsub(/[^0-9]/, ''))
      end
    end
    describe 'negativa valores de retirada de saldo seja saque ou trasnferencia' do
      before(:each) do
        @accounts = []
        2.times do
          @accounts << FactoryBot.create(:new_account)
        end
      end
      context 'negativa valores na transferencia no extrato:' do
        it 'negativa value e fee_transfer' do
          extract_transfer_sent = build(:new_extract_transfer_sent, account: @accounts.first)
          extract_transfer_sent.acc_transfer_agency = @accounts.second&.agency
          extract_transfer_sent.acc_transfer_number = @accounts.second&.number
          extract_transfer_sent.save
          expect(extract_transfer_sent.value.negative?).eql?(true)
          expect(extract_transfer_sent.fee_transfer.negative?).eql?(true)
        end
      end
      context 'negativa valor no saque:' do
        it 'negative value' do
          extract_withdraw = create(:new_extract_withdraw, account: @accounts.first)
          extract_withdraw.save
          expect(extract_withdraw.value.negative?).eql?(true)
        end
      end
    end
  end

  describe 'Scopes' do
    before(:each) do
      account = create(:new_account)
      @extracts = []
      2.times do
        @extracts << create(:new_extract_withdraw, account: account, date: Time.new(2022, 02, 02))
      end
      2.times do
        @extracts << create(:new_extract_withdraw, account: account, date: Time.new(2022, 02, 10))
      end
    end


    describe 'by_start_date' do
      it 'retorna lista de extratos a partir da data de inicio' do
        extracts = Bank::Model::Extract.by_start_date('2022-02-02')
        expect(extracts.length).to eq(4)
      end
      it 'nao retorna lista de extratos a partir da data de inicio' do
        extracts = Bank::Model::Extract.by_start_date('2022-02-11')
        expect(extracts.length).to eq(0)
      end
    end

    describe 'by_end_date' do
      it 'retorna lista de extratos até data fim' do
        extracts = Bank::Model::Extract.by_end_date('2022-02-10')
        expect(extracts.length).to eq(4)
      end
      it 'nao retorna lista de extratos até data fim' do
        extracts = Bank::Model::Extract.by_end_date('2022-02-01')
        expect(extracts.length).to eq(0)
      end
    end

    describe 'by_start_date and by_end_date' do
      it 'retorna lista de extratos no intervalo da data de inicio e data fim' do
        extracts = Bank::Model::Extract
                     .by_start_date('2022-02-02')
                     .by_end_date('2022-02-10')
        expect(extracts.length).to eq(4)
      end
      it 'nao retorna lista de extratos no intervalo da data de inicio e data fim' do
        extracts = Bank::Model::Extract
                     .by_start_date('2022-02-11')
                     .by_end_date('2022-02-20')
        expect(extracts.length).to eq(0)
      end
    end
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
