module AdministratorsHelper
  def admin_sign_in(administrator)
    session[:session_token]=administrator.web_session_id
    session[:login_type]="admin"
  end

  def admin_signed_in?
    !current_admin.nil?
  end

  def current_admin
    @current_administrator ||= Administrator.find_by(:web_session_id => session[:session_token])
  end

  def current_admin?(administrator)
    current_admin == administrator
  end
  def admin_sign_out
    @current_administrator = nil
    session.delete(:session_token)
    session.delete(:login_type)
  end
    
end
