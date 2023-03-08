class ApplicationController < ActionController::API
  def format_error(context, object_name)
    if context.message.present?
      { message: context.message }
    elsif context.send(object_name)&.errors&.present?
      context.send(object_name).errors.full_messages
    else
      { message: 'Error when updating or create.' }
    end
  end
end
