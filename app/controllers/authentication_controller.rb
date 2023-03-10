class AuthenticationController < ApplicationController

  def login
    @account = Bank::Model::Account.by_agency_and_number(params[:agency], params[:account_number])
                                   .first

    if @account.client&.authenticate(params[:password])
      token = Bank::Utils::JsonWebToken.encode(account_id: @account.id)
      render json: { token: token }, status: :ok
    else
      render json: { message: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_account_params
    params.permit(:agency, :account_number, :password)
  end
end
