# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bank::Model::Client, type: :model do

  describe 'Associations' do
    it { should have_one(:account).class_name('Bank::Model::Account') }
  end

  describe 'Callbacks' do
    describe 'limpar cpf:' do
      it 'remove caracteres não numericos' do
        cpf = Faker::CPF.cpf
        client = create(:new_client, cpf: cpf)
        client.save
        expect(client.cpf).to eq(cpf.gsub(/[^0-9]/, ''))
      end
    end
  end

  describe 'Validations' do
    subject {
      create(:new_client)
    }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:cpf) }
    it { should validate_presence_of(:date_of_birth) }
    it { should validate_presence_of(:email) }

    describe 'validate_client:' do
      context 'email invalido' do
        it 'não deixa salvar' do
          client = build(:new_client, email: 'faker_email1234')
          expect(client.save).to be_falsey
        end
      end

      context 'name, last_name tamanho invalido' do
        it 'não deixa salvar' do
          client = build(:new_client, name: 'ca', last_name: 'ca')
          expect(client.save).to be_falsey
        end
      end

      context 'cpf existe' do
        it 'não deixa salvar' do
          client = build(:new_client, cpf: Bank::Model::Client.first&.cpf)
          expect(client.save).to be_falsey
        end
      end
    end
  end
end
