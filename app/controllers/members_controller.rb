class MembersController < ApplicationController
  include MembersHelper
  include ApplicationHelper
  require 'active_record_union'
  def index
    @members = MemberTableOne.all.union(MemberTableTwo.all).order(:email)
    #@members = get_all_members
    #@members = MemberTableOne.all
  end

  def new
  end

  def create
    @message = Hash.new
    @member_table_count = get_global_var(:member_table_count)
    @params = member_create_params
    @table_num = Digest::SHA1.hexdigest(
      @params[:email] ).to_i(16) % @member_table_count
    case @table_num
      when 0
        @member = MemberTableOne.new(@params)
      when 1
        @member = MemberTableTwo.new(@params)
    end
    if @member.save
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.register_error")
    end
    render :json => @message.to_json
  end

  def edit
    @table_number = params[:table_number]
    @id = params[:id]
    case @table_number
      when "1"
        @member = MemberTableOne.find(@id)
      when "2"
        @member = MemberTableTwo.find(@id)
    end
  end

  def update
    @message = Hash.new
    @params = member_update_params
    @table_number = params[:table_number]
    @id = params[:id]

    case @table_number
      when "1"
        @member = MemberTableOne.find(@id)
      when "2"
        @member = MemberTableTwo.find(@id)
    end
    if !@member.nil?
      if @member.update(@params)
        @message[:result] = true
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.update_error")
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.wrrong_identity")
    end
      render :json => @message.to_json
        

  end

  def login
  end

  def login_create
    @message = Hash.new
    @params = member_login_params
    @member = get_member(@params[:email]) 
    if !@member.nil? && @member.authenticate(@params[:password])
      member_sign_in(@member)
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.login_error")
    end
      render :json => @message.to_json
  end

  def ratting
  end

  def follow
  end


  def logout
    @message = Hash.new
    member_sign_out
    @message[:result] = true
    render :json => @message.to_json
  end
  private
  def member_create_params
    params.require(:member).permit(:email,:password)
  end
  def member_update_params
    params.require(:member).permit(:nickname,:password)
  end
  def member_login_params
    params.require(:member).permit(:email,:password);
  end

end
