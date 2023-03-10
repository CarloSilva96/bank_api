module Bank
  module Utils
    class JsonWebToken
      KEY_SECRET = Rails.application.secrets.secret_key_base.to_s

      def self.encode(payload, exp = 2.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, KEY_SECRET)
      end

      def self.decode(token)
        decoded = JWT.decode(token, KEY_SECRET)[0]
        HashWithIndifferentAccess.new decoded
      end
    end
  end
end