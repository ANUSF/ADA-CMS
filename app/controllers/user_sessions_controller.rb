class UserSessionsController < OpenidClient::SessionsController
  #DEFAULT_SERVER='http://:4000'
  DEFAULT_SERVER='http://178.79.149.181:81'

  protected

  def force_default?
    true
  end

  def default_login
    DEFAULT_SERVER
  end

  def logout_url_for(identity)
    if identity and identity.starts_with? DEFAULT_SERVER
      "#{DEFAULT_SERVER}/logout"
    else
      nil
    end
  end
end
