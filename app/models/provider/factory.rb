class Provider::Factory
  def self.get_instance(provider, uid = nil)
    provider = provider.to_sym
    case provider
      when :facebook
        Provider::Facebook.new(uid)
      when :vkontakte
        Provider::Vkontakte.new(uid)
      when :google_oauth2
        Provider::GoogleOauth2.new(uid)
      when :twitter
        Provider::Twitter.new(uid)
      when :github
        Provider::Github.new(uid)
      when :linkedin
        Provider::Linkedin.new(uid)
      else
        raise NoMethodError, "Not defined provider class"
    end
  end
end
