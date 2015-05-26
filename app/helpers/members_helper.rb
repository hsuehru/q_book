module MembersHelper
  def check_member_email_exist?(email = nil)
    if !email.nil?
      @member=MemberTableOne.find_by(:email => email)
      if !@member.nil?
        return true
      end
      @member=MemberTableTwo.find_by(:email => email)
      if !@member.nil?
        return true
      end

      return false

    end

  end

  def get_all_members
    @table1 =  MemberTableOne.all
    @table2 = MemberTableTwo.all
    @tableAll = @table1 + @table2
    return @tableAll
  end

  def get_member(email = nil)
    if !email.nil?
      @member_table_count = get_global_var(:member_table_count)
      @hash = Digest::SHA1.hexdigest(email).to_i(16) % @member_table_count
      case @hash
        when 0
          @member=MemberTableOne.find_by(:email => email)
        when 1
          @member=MemberTableTwo.find_by(:email => email)
      end
      
      if !@member.nil?
        return @member
      else
        return nil
      end
    end
  end
  def member_sign_in(member)
    session[:session_token] = member.web_session_id
    session[:login_type]="member"
    session[:table_number] = member.table_number
    @current_member = member
  end

  def member_signed_in?
    !current_admin.nil?
  end

  def current_member
    if @current_member.nil?
      case session[:table_number]
        when "1"
          @current_member = MemberTableOne.find_by(
            :web_session_id => session[:session_token])
        when "2"
          @current_member = MemberTableTwo.find_by(
            :web_session_id => session[:session_token])
      end
    else
      return @current_member
    end
  end

  def current_member?(administrator)
    current_admin == administrator
  end
  def member_sign_out
    @current_member = nil
    session.delete(:session_token)
    session.delete(:login_type)
    session.delete(:table_number)
  end
    
end
