module Api
  module V1
    class AccountsController < ApplicationController

      before_action :set_account, only: %i[show update]

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
          render :show, status: 201
        else
          render json: format_error(context, :account), status: context.status || 400
        end
      end

      def show; end

      private

      def set_account
        @account = Bank::Model::Account.find(params[:id])
      end

      def account_params
        params.permit(client_attributes: %i[name last_name cpf email date_of_birth password])
      end

    end
  end
end