require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Base < OmniAuth::Strategies::OAuth2
      option :token_params, {parse: :json}
      option :provider_ignores_state, true

      uid do
        raw_info['openid']
      end

      info do
        {
          nickname:   raw_info['nickname'],
          sex:        raw_info['sex'],
          province:   raw_info['province'],
          city:       raw_info['city'],
          country:    raw_info['country'],
          headimgurl: raw_info['headimgurl']
        }
      end

      extra do
        {raw_info: raw_info}
      end

      def request_phase
        params = client.auth_code.authorize_params.merge(redirect_uri: callback_url).merge(authorize_params)
        params["appid"] = params.delete("client_id")
        redirect client.authorize_url(params)
      end

      def raw_info
        @uid ||= access_token["openid"]
        @raw_info ||= begin
          access_token.options[:mode] = :query
          if %w(snsapi_userinfo snsapi_login).include? access_token["scope"]
            check_access_token!
            response = access_token.get("/sns/userinfo", :params => {"openid" => @uid}, parse: :text)
            @raw_info = JSON.parse(response.body.gsub(/[\u0000-\u001f]+/, ''))
          else
            @raw_info = { "openid" => @uid }
          end
        end
      end

      protected
      def build_access_token
        params = {
          'appid' => client.id,
          'secret' => client.secret,
          'code' => request.params['code'],
          'grant_type' => 'authorization_code'
          }.merge(token_params.to_hash(symbolize_keys: true))
        client.get_token(params, deep_symbolize(options.auth_token_params))
      end

      def check_access_token!
        response = access_token.get("/sns/auth", :params => {"openid" => @uid}, parse: :json).parsed
        unless response["errcode"] == 0 && response["errmsg"] == 'ok'
          access_token.client.options[:token_url] = "/sns/oauth2/refresh_token"
          self.access_token = access_token.refresh!(appid: client.id, parse: :json)
          access_token.client.options[:token_url] = "/sns/oauth2/access_token"
        end
      end
    end
  end
end
