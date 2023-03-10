module Api
  module V1
    class AccountsController < ApplicationController

      before_action :set_account, only: %i[show update close_accounts transfers]

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
          render json: format_error(context, :account), status: context.status || 400
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
      def close_accounts
        context = ::Account::Close.call(account: @account)
        if context.success?
          head :no_content
        else
          render json: format_error(context, :account), status: context.status || :bad_request
        end
      end
      def deposits
        context = ::Account::Deposit::DepositOrganizer.call(deposit_params: deposit_params)
        @voucher = context.voucher
        if context.success?
          render :voucher, status: :ok
        else
          render json: format_error(context, :voucher), status: context.status || 400
        end
      end

      def transfers
        context = ::Account::Transfer::TransferOrganizer.call(transfer_params: transfer_params, source_account: @account)
        @voucher = context.voucher
        if context.success?
          render :voucher, status: :ok
        else
          render json: format_error(context), status: context.status || 400
        end
      end

      def balances
        account = Bank::Model::Account.select(:id, :balance).find(params[:id])
        date = Time.zone.now
        if account.present?
          render json: { balance: account.balance, date: date } , status: :ok
        else
          byebug
          render json: { message: 'Account not found.' }, status: :not_found
        end
      end

      def extracts
        @extracts = Bank::Model::Extract.where(account_id: params[:id])
                                        .page(params[:page])
                                        .per(params[:per_page])
                                        .order(id: :asc)
      end

      private

      # TODO: TRATAR EXCEPTIONS GERAL
      def set_account
        @account = Bank::Model::Account.find(params[:id])
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