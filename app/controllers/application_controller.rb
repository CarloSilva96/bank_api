class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :required_params

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def required_params(error)
    render json: { error: error.message }, status: :bad_request
  end
  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = Bank::Utils::JsonWebToken.decode(header)
      @current_account = Bank::Model::Account.find(@decoded[:account_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: e.message }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { message: 'required JSON WEB TOKEN' }, status: :unauthorized
    end
  end

  def format_error(context, object_name=nil)
    if context.message.present?
      { message: context.message }
    elsif context.send(object_name)&.errors&.present?
      context.send(object_name).errors.full_messages
    else
      { message: 'Error when updating or create.' }
    end
  end
end
