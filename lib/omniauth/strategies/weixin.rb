require 'omniauth/strategies/base'

module OmniAuth
  module Strategies
    class Weixin < OmniAuth::Strategies::Base
      option :name, "weixin"

      option :client_options, {
        site:          "https://api.weixin.qq.com",
        authorize_url: "https://open.weixin.qq.com/connect/oauth2/authorize#wechat_redirect",
        token_url:     "/sns/oauth2/access_token",
        token_method:  :get
      }

      option :authorize_params, {scope: "snsapi_userinfo"}
    end
  end
end
