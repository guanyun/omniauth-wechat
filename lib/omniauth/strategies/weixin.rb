require 'omniauth/strategies/base'

module OmniAuth
  module Strategies
    class Weixin < OmniAuth::Strategies::Base
      option :client_options, {
        :site => 'https://api.weixin.qq.com',
        :authorize_url => 'https://open.weixin.qq.com/connect/oauth2/authorize',
        :token_url => "https://api.weixin.qq.com/sns/oauth2/access_token"
      }
    end

    def get_user_info
      if options[:scope] == 'snsapi_base'
        Wechat.api.user(uid)
      else
        super
      end
    end
  end
end

OmniAuth.config.add_camelization('weixin', 'Weixin')
