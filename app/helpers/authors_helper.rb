module AuthorsHelper
  def author_sign_in(author)
    session[:session_token] = author.web_session_id
    session[:login_type]="author"
    @current_author = author
  end

  def author_signed_in?
    !current_author.nil?
  end

  def current_member
    @current_author ||= Author.find_by(
      :web_session_id => session[:session_token])
  end

  def current_author?(author)
    current_author == author
  end
  def member_sign_out
    @current_author = nil
    session.delete(:session_token)
    session.delete(:login_type)
    session.delete(:table_number)
  end
    
end
