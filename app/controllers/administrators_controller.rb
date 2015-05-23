class AdministratorsController < ApplicationController
  include AdministratorsHelper
  before_action :authen_login, :only => [:edit]
  def index
    #render :layout => false
    @administrators = Administrator.all
  end


  def new
    @administrator = Administrator.new
    @administrator_types=AdministratorType.select(:name,:id)
  end

  def create
    @message = Hash.new
    @param=administrator_params
    if Administrator.find_by(:email => @param[:email])
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.duplicate_email_error")
    else
      @administrator=Administrator.new(@param)
      @a=administrator_params

      if @administrator.save
        @message[:result] = true
      else
        @message[:error_message] = I18n.t("error_info.register_error")
      end
    end
      render :json => @message.to_json
  end

  def edit
    @administrator=Administrator.find(params[:id])
    if !current_admin?(@administrator)
      redirect_to administrators_login_path 
    end
  end

  def update
    @message=Hash.new
    @param=administrator_update_params
    @current_admin=current_admin
    if current_admin?(@current_admin)
      if @current_admin.update(@param)
        @message[:result] = true
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.update_error")
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.wrrong_identify")
    end
    render :json => @message.to_json
  end

  def block_account
    @message = Hash.new
    @current_admin = current_admin
    if @current_admin.administrator_type.name == "master"
      @admin=Administrator.find(params[:id])
      @admin.active=false
      if @admin.save
        @message[:result] = true
      else 
        @message[:result] = false
        @message[:error_message] = I18n.t(
          "error_info.block_administrator_account_error")
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t(
        "error_info.wrrong_identity")
    end
    render :json => @message.to_json
  end

  def administrator_type_index
    @administrator_types = AdministratorType.all
  end

  def administrator_type_new
    @administrator_type = AdministratorType.new
  end


  def administrator_type_create
    @message = Hash.new
    @administrator_type = AdministratorType.new(administrator_type_params)
    if @administrator_type.save
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.administrator_type_create_error")
    end
    render :json => @message.to_json, :layout => false
  end

  def administrator_type_edit
    @administrator_type = AdministratorType.find(params[:id])
  end

  def administrator_type_update
    @message=Hash.new
    @param = administrator_type_params
    @current_admin = current_admin
    @administrator_type = AdministratorType.find(params[:format])
    if @administrator_type.update(@param)
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.update_error")
    end
    render :json => @message.to_json
  end

  def administrator_type_destory
    
    @message=Hash.new
    @current_admin = current_admin
    @administrator_type = AdministratorType.find_by(:id => params[:format])
    if !@administrator_type.nil? && @administrator_type.delete
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.destroy_error")
    end
    render :json => @message.to_json
  end

  def login
    @administrator = Administrator.new
  end

  def login_create
    @message = Hash.new
    @param = administrator_login_params 
    @administrator = Administrator.find_by(:email => @param[:email])
    if @administrator && @administrator.authenticate(@param[:password])
      @message[:result] = true
      admin_sign_in(@administrator)
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.login_error")
    end
    render :json => @message.to_json, :layout => false
      
  end

  def logout
    admin_sign_out
    redirect_to show_api_test_index_path
  end

private

  def authen_login
    if !admin_signed_in?
      redirect_to administrators_login_path
    end
  end

  def administrator_params
    params.require(:administrator).permit(:email,:password,
    :administrator_type_id)
  end

  def administrator_update_params
    params.require(:administrator).permit(:password, :administrator_type_id)
  end

  def administrator_login_params
    params.require(:administrator).permit(:email,:password)
  end

  def administrator_type_params
    params.require(:administrator_type).permit(:name)
  end

end

