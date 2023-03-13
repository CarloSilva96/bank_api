module Api
  module V1
    class AccountsController < ApplicationController
      before_action :authorize_request, except: %i[index create deposits]
      before_action :set_account, except: %i[index create deposits]

      def index
        @accounts = Bank::Model::Account.by_agency(params[:agency])
                                           .by_number(params[:number])
                                           .page(params[:page])
                                           .per(params[:per_page])
                                           .order(id: :asc)
      end

      def create
        context = ::Account::Create.call(account_params: account_params)
        @account = context.account
        if context.success?
          render :show, status: :created
        else
          render json: format_error(context, :account), status: context.status
        end
      end

      def update
        context = ::Account::Update.call(account_params: account_update_params, account: @account)
        @account = context.account
        if context.success?
          render :show, status: :ok
        else
          render json: format_error(context, :account), status: context.status || 400
        end
      end

      def show; end

      def close
        context = ::Account::Close.call(account: @current_account)
        if context.success?
          render json: { message: 'account closed successfully' }, status: :ok
        else
          render json: format_error(context, :account), status: context.status || :bad_request
        end
      end

      def deposits
        context = ::Account::Deposit::DepositOrganizer.call(deposit_params: deposit_params,
                                                            agency: deposit_params[:account_agency],
                                                            account_number: deposit_params[:account_number])
        @voucher = context.voucher
        if context.success?
          render :voucher, status: :created
        else
          render json: format_error(context, :voucher), status: context.status
        end
      end

      def transfers
        context = ::Account::Transfer::TransferOrganizer.call(transfer_params: transfer_params,
                                                              source_account: @current_account,
                                                              agency: transfer_params[:acc_transfer_agency],
                                                              account_number: transfer_params[:acc_transfer_number])
        @voucher = context.voucher
        if context.success?
          render :voucher, status: :ok
        else
          render json: format_error(context), status: context.status
        end
      end

      def balances
        balance = Bank::Model::Account.find(@current_account.id).balance
        date = Time.zone.now
        if balance.present?
          render json: { balance: balance, date: date } , status: :ok
        end
      end

      def withdraws
        context = ::Account::Withdraw.call(account: @current_account, withdraw: params.permit(:withdraw))
        @voucher = context.voucher
        if context.success?
          render :voucher, status: :ok
        else
          render json: format_error(context, :account), status: context.status
        end
      end

      def extracts
        @extracts = Bank::Model::Extract.where(account_id: @current_account.id)
                                        .by_start_date(params[:start_date])
                                        .by_end_date(params[:end_date])
                                        .page(params[:page])
                                        .per(params[:per_page])
                                        .order(id: :asc)
      end

      private

      def set_account
        @account = Bank::Model::Account.find(params[:id])
        render json: { message: 'without permission' }, status: :forbidden unless @account.id.eql?(@current_account.id)
      end

      def account_params
        params.permit(client_attributes: %i[name last_name cpf email date_of_birth password])
      end

      def account_update_params
        params.permit(:id, client_attributes: %i[id last_name email password])
      end

      def deposit_params
        params.permit(:value, :depositing_name, :depositing_cpf, :account_agency, :account_number)
      end

      def transfer_params
        params.permit(:value, :acc_transfer_agency, :acc_transfer_number)
      end
    end
  end
end