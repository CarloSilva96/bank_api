require 'rails_helper'

RSpec.describe "Accounts Requests", type: :request do
  let(:valid_login_account) do
    valid_login
  end

  let(:account_rand) do
    create(:new_account)
  end

  describe 'GET /api/v1/accounts INDEX' do
    context 'Quando não existem accounts salvas' do
      it 'retorna array vazio' do
        get api_v1_accounts_path
        expect_json(total_results: 0, results: [])
        expect(response).to have_http_status(200)
      end
    end

    context 'Quando existem accounts salvas' do
      before(:each) do
        @accounts = []
        5.times do
          @accounts << create(:new_account)
        end
      end

      it 'retorna todos os dados da conta' do
        get api_v1_accounts_path
        expect(json_body[:total_results]).to eq(@accounts.length)
        expect_json_keys('results.*', %i[id agency number status balance client])
        expect_json_keys('results.*.client', %i[id name last_name cpf])
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /api/v1/accounts CREATE' do
    context 'Quando passa dados validos' do
      it 'salva e retorna account' do
        account_attributes = { client_attributes: FactoryBot.attributes_for(:new_client) }
        expect do
          post api_v1_accounts_path,
               params: account_attributes
        end.to change { Bank::Model::Account.count }.by(1)
        expect(response).to have_http_status(201)
        expect_json_keys(%i[id agency number balance client])
        expect_json_keys('client', %i[id name last_name cpf email date_of_birth])
      end
    end

    context 'Quando passa dados invalidos' do
      it 'não salva e retorna 422' do
        account_attributes = { client_attributes: {} }
        post api_v1_accounts_path,
             params: account_attributes
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'GET /api/v1/accounts/:id SHOW' do
    context 'Quando cliente está autenticado' do
      context 'Quando passa id respectivo da conta do cliente' do
        it 'retorna 200' do
          get api_v1_account_path(id: valid_login_account[:id]),
              headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }
          account = Bank::Model::Account.find(valid_login_account[:id])
          expect(response).to have_http_status(200)
          expect_json_keys(%i[id agency number balance])
          expect_json_keys('client.', %i[id name last_name cpf email date_of_birth])
          expect_json(id: account.id, agency: account.agency, number: account.number, balance: account.balance.to_s)
          expect_json('client', id: account.client.id, name: account.client.name, last_name: account.client.last_name,
                      cpf: account.client.cpf, email: account.client.email)
        end
      end

      context 'Quando cliente tenta acessar outra conta diferente da sua autenticada' do
        it 'retorna 403' do
          get api_v1_account_path(id: account_rand.id),
              headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }

          expect(response).to have_http_status(403)

        end
      end

    end

    context 'Quando client não está autenticado' do
      it 'retorna 401' do
        get api_v1_account_path(id: account_rand.id)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT /api/v1/accounts/:id UPDATE' do
    context 'Quando cliente está autenticado' do
      context 'Quando cliente está acessando sua respectiva conta' do
        it 'atualiza dados e retorna 200' do
          params_account = { id: valid_login_account[:id] }
          params_account[:clients_attributes] = {
            last_name: 'Ciclano Silva',
            email: 'ciclanosilva@gmail.com'
          }

          put api_v1_account_path(id: valid_login_account[:id]),
              headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
              params: params_account

          account = Bank::Model::Account.find(valid_login_account[:id])

          expect(response).to have_http_status(200)
          expect_json_keys(%i[id agency number balance])
          expect_json_keys('client.', %i[id name last_name cpf email date_of_birth])
          expect_json(id: account.id)
          expect_json('client', id: account.client.id, last_name: account.client.last_name, email: account.client.email)
        end
      end

      context 'Quando cliente tenta acessar outra conta diferente da sua autenticada' do
        it 'não atualiza dados e retorna 403' do
          put api_v1_account_path(id: account_rand.id),
              headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
              params: attributes_for(:new_client)
          expect(response).to have_http_status(403)
        end
      end
    end

    context 'Quando cliente não está autenticado' do
      it 'não atualiza dados e retorna 401' do
        put api_v1_account_path(id: account_rand.id),
            params: attributes_for(:new_client)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PATCH /api/v1/accounts/:id/close CLOSE' do
    context 'Quando cliente está autenticado' do
      context 'Quando cliente está acessando sua respectiva conta' do
        it 'encerra conta e retorna 204' do

          patch close_api_v1_account_path(id: valid_login_account[:id]),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }

          account = Bank::Model::Account.find(valid_login_account[:id])

          expect(response).to have_http_status(204)
          expect(account.status).to eq('closed')
        end
      end

      context 'Quando cliente tenta acessar outra conta diferente da sua autenticada' do
        it 'não encerra conta e retorna 403' do
          patch close_api_v1_account_path(id: account_rand.id),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }

          account = Bank::Model::Account.find(valid_login_account[:id])
          expect(response).to have_http_status(403)
          expect(account.status).to eq('active')
        end
      end
    end

    context 'Quando cliente não está autenticado' do
      it 'não encerra conta e retorna 401' do
        patch close_api_v1_account_path(id: account_rand.id)
        expect(response).to have_http_status(401)
      end
    end

  end

  describe 'POST /api/v1/accounts/deposits DEPOSITS' do
    before(:each) do
      @account = FactoryBot.create(:new_account)
      @deposit_params = {
        depositing_name: Faker::Name.name,
        depositing_cpf: Faker::CPF.cpf,
        value: 200.00,
        account_agency: @account.agency,
        account_number: @account.number
      }
    end

    context 'Quando depositante passa dados válidos' do
      it 'faz deposito e retorna 201' do
        post deposits_api_v1_accounts_path, params: @deposit_params
        expect(response).to have_http_status(201)
        expect(@account.reload.balance).to eq(@deposit_params[:value])
      end
    end

    context 'Quando depositante passa valor negativo' do
      it 'não faz deposito e retorna 422' do
        @deposit_params[:value] = -10
        post deposits_api_v1_accounts_path, params: @deposit_params
        expect(response).to have_http_status(422)
      end
    end

    context 'Quando depositante não passa dados' do
      it 'não faz deposito e retorna 422' do
        deposit_params_empty = {}
        post deposits_api_v1_accounts_path, params: deposit_params_empty
        expect(response).to have_http_status(422)
      end
    end

    context 'Quando depositante passa agencia e numero da conta invalidos' do
      it 'não faz deposito e retorna 422' do
        @deposit_params[:account_agency] = 0000
        @deposit_params[:account_number] = 00000000
        post deposits_api_v1_accounts_path, params: @deposit_params
        expect(response).to have_http_status(422)
      end
    end

  end

  describe 'GET /api/v1/accounts/:id/balances BALANCES' do
    context 'Quando cliente está autenticado' do
      context 'Quando cliente está acessando sua respectiva conta' do
        it 'retorna saldo e data do saldo com status 200' do
          get balances_api_v1_account_path(id: valid_login_account[:id]),
              headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }

          account = Bank::Model::Account.find(valid_login_account[:id])

          expect(response).to have_http_status(200)
          expect_json_keys(%i[balance date])
          expect_json(balance: account.balance.to_s)
        end
      end

      context 'Quando cliente tenta acessar outra conta diferente da sua autenticada' do
        it 'retorna 403' do
          get balances_api_v1_account_path(id: account_rand.id),
              headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }

          expect(response).to have_http_status(403)
        end
      end
    end

    context 'Quando client não está autenticado' do
      it 'retorna 401' do
        get balances_api_v1_account_path(id: account_rand.id)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PATCH /api/v1/accounts/:id/withdraws WITHDRAWS' do
    context 'Quando cliente está autenticado' do
      context 'Quando cliente está acessando sua respectiva conta' do
        it 'faz saque quando tem saldo disponivel e retorna 200' do

          account = Bank::Model::Account.find(valid_login_account[:id])
          account.balance = 100
          account.save

          patch withdraws_api_v1_account_path(id: valid_login_account[:id]),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
                params: { withdraw: 100.0 }

          expect(response).to have_http_status(200)
          expect(BigDecimal(json_body[:value])).to eq(-100.0)
          expect(account.reload.balance).to eq(0)
          expect_json_keys(%i[id operation_type value date])
        end
      end

      context 'Quando cliente não tem saldo disponivel ' do
        it 'não faz saque e retorna 422' do

          patch withdraws_api_v1_account_path(id: valid_login_account[:id]),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
                params: { withdraw: 100 }

          expect(response).to have_http_status(422)
        end
      end

      context 'Quando passa dados invalidos ' do
        it 'não faz saque e retorna 422' do

          patch withdraws_api_v1_account_path(id: valid_login_account[:id]),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
                params: { withdraw: -100 }

          expect(response).to have_http_status(422)
        end
      end

      context 'Quando cliente tenta acessar outra diferente da sua autenticada' do
        it 'não faz saque e retorna 403' do
          patch withdraws_api_v1_account_path(id: account_rand.id),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
                params: { withdraw: 100.0 }

          expect(response).to have_http_status(403)
        end
      end
    end

    context 'Quando cliente não está autenticado' do
      it 'não faz saque e retorna 401' do
        patch withdraws_api_v1_account_path(id: account_rand.id),
              params: { withdraw: 100.0 }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST /api/v1/accounts/:id/transfers TRANSFERS' do
    before(:each) do
      @account_received = create(:new_account)
      account = Bank::Model::Account.find(valid_login_account[:id])
      account.balance = 100
      account.save
      @account_sent = account

      @transfer_params = {
        value: 10,
        acc_transfer_agency: @account_received.agency,
        acc_transfer_number: @account_received.number
      }
    end

    context 'Quando cliente está autenticado' do
      context 'Quando cliente está acessando sua respectiva conta' do
        context 'Quando cliente tem saldo suficiente' do
          it 'faz transferencia e retorna 200' do

            post transfers_api_v1_account_path(id: @account_sent.id),
                 headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
                 params: @transfer_params

            expect(response).to have_http_status(200)
            expect(@account_received.reload.balance).to eq(10)
            expect(@account_received.extracts.first.value).to eq(10)
            expect_json_keys(%i[id operation_type value date acc_transfer_agency acc_transfer_number])
            expect_json(operation_type: 'transfer_sent', acc_transfer_agency: @account_received.agency,
                        acc_transfer_number: @account_received.number)
            expect_json(
              value: -> value {
                expect(BigDecimal(value)).to eq(-10)
              }
            )
          end
        end

        context 'Quando cliente não tem saldo suficiente' do
          it 'não faz transferencia e retorna 422' do
            @account_sent.balance = 0
            @account_sent.save

            post transfers_api_v1_account_path(id: @account_sent.id),
                 headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
                 params: @transfer_params

            expect(response).to have_http_status(422)
          end
        end

        context 'Quando client tenta transferir para ele mesmo' do
          it 'não faz transferencia e retorna 422' do
            @transfer_params[:acc_transfer_agency] = @account_sent.agency
            @transfer_params[:acc_transfer_number] = @account_sent.number

            post transfers_api_v1_account_path(id: @account_sent.id),
                 headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
                 params: @transfer_params

            expect(response).to have_http_status(422)
          end
        end
      end

      context 'Quando cliente tenta acessar outra conta diferente da sua autenticada' do
        it 'não transferencia e retorna 403' do
          patch withdraws_api_v1_account_path(id: @account_received.id),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" },
                params: { withdraw: 100.0 }

          expect(response).to have_http_status(403)
        end
      end
    end

    context 'Quando cliente não está autenticado' do
      it 'não faz saque e retorna 401' do
        post transfers_api_v1_account_path(id: account_rand.id),
             params: @transfer_params
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/accounts/:id/extracts EXTRACTS' do
    context 'Quando cliente está autenticado e acessando sua conta respectiva' do
      context 'Quando não existem extracts salvos' do
        it 'retorna array vazio e status 200' do
          get extracts_api_v1_account_path(id: valid_login_account[:id]),
              headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }
          expect_json(total_results: 0, results: [])
          expect(response).to have_http_status(200)
        end
      end

      context 'Quando cliente está acessando sua respectiva conta' do
        before(:each) do
          @account_source = Bank::Model::Account.find(valid_login_account[:id])
          @account_source.balance += 1000
          @account_source.save

          @account_received = create(:new_account)
          @account_source.extracts << create(:new_extract_deposit)
          @account_source.extracts << create(:new_extract_withdraw, account: @account_source)

          extract_sent = build(:new_extract_transfer_sent, account: @account_source)
          extract_sent.acc_transfer_agency = @account_received.agency
          extract_sent.acc_transfer_number = @account_received.number
          @account_source.extracts << extract_sent
        end

        context 'Quando existem extracts salvos' do
          it 'retorna todos os extracts da conta e status 200' do
            get extracts_api_v1_account_path(id: valid_login_account[:id]),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }
            expect(json_body[:total_results]).to eq(3)
            expect_json_keys('results.*', %i[id date value operation_type])
            expect(response).to have_http_status(200)
          end
        end
      end


      context 'Quando cliente tenta acessar outra conta diferente da sua autenticada' do
        it 'não retorna e extracts e retorna 403' do
          get extracts_api_v1_account_path(id: account_rand.id),
                headers: { 'Authorization': "Bearer #{valid_login_account[:token]}" }

          expect(response).to have_http_status(403)
        end
      end
    end

    context 'Quando cliente não está autenticado' do
      it 'não lista extracts e retorna 401' do
        get extracts_api_v1_account_path(id: account_rand.id)
        expect(response).to have_http_status(401)
      end
    end
  end
end
