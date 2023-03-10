class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
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
