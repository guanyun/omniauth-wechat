require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Base < OmniAuth::Strategies::OAuth2
      option :provider_ignores_state, true

      def request_phase
        redirect client.authorize_url(authorize_params) + "#wechat_redirect"
      end

      def authorize_params
        options[:scope] = "snsapi_userinfo" if options[:scope].nil?

        {
          :appid => options.client_id,
          :redirect_uri => callback_url,
          :response_type => 'code',
          :scope => options[:scope]
        }
      end

      def token_params
        params = super
        params.merge({:appid => options.client_id, :secret => options.client_secret})
      end

      def build_access_token
        client.auth_code.get_token(
          request.params['code'],
          {:redirect_uri => callback_url, :parse => :json}.merge(token_params.to_hash(:symbolize_keys => true)),
          {:mode => :query, :param_name => 'access_token'}
        )
      end

      uid do
        @uid ||= begin
          access_token["openid"]
        end
      end

      info do
        {
          :nickname => raw_info['nickname'],
          :name => raw_info['nickname'],
          :image => raw_info['headimgurl'],
        }
      end

      extra do
        {
          :raw_info => raw_info
        }
      end

      def raw_info
        @raw_info ||= get_user_info
      end

      def get_user_info
        access_token.get(
          '/sns/userinfo',
           {:params => {:openid => uid}, :parse => :json}
        ).parsed
      end
    end
  end
end
