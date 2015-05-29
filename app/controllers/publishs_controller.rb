class PublishsController < ApplicationController
  include AdministratorsHelper
  include PublishsHelper
  include AuthorsHelper
  before_action :authen_login, :only => [:manager_index]
  before_action :authen_master_right, :only => [:manager_index,
                                                :manager_master_list_remove,
                                                :manager_sales_list_remove]
  before_action :only => [:manager_index] do
    #here can use function and pass parameter into function
  end

  def index
    @publish_companies = PublishCompany.all
  end

  def edit
    @publish_company = PublishCompany.find(params[:id])
  end

  def update
    @message = Hash.new
    @publish_company = PublishCompany.find(params[:id])
    @params = publish_update_params
    if @publish_company.update(@params)
      @message[:result] = true 
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.update_error")
    end
    render :json => @message.to_json
  end

  def new
    @publish = PublishCompany.new
  end

  def create
    @message = Hash.new
    @params = publish_create_params
    @publish = PublishCompany.new(@params)
    if @publish.save
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.create_error")
    end
    render :json => @message.to_json
  end

  def delete 
  end

  def account_index
  end

  def account_new 
    @book_sales_account_types = BookSalesAccountType.all
    @publish_commapies = PublishCompany.all
    @book_sales_account = BookSalesAccount.new
  end

  def account_create
    @message = Hash.new
    @params = account_create_params
    @publish_company = PublishCompany.find(@params[:publish_company_id])
    @book_sales_account_type_id = @params[:book_sales_account_type_id]
    @params.delete(:publish_company_id)
    @params.delete(:book_sales_account_type_id)
    ActiveRecord::Base.transaction do
      @book_sales = BookSalesAccount.new(@params)
      @book_sales.publish_id_list = @publish_company.id
      if @book_sales.save
        @publish_company = append_to_publish_id_list(@publish_company,
                             @book_sales_account_type_id,
                             @book_sales)
        if !@publish_company.nil? && @publish_company.save
          @message[:result] = true
        else
          @message[:result] = false
          @message[:error_message] = I18n.t("error_info.create_error")
        
          raise ActiveRecord::Rollback
        end
      
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.create_error")
      end
      
    end
    render :json => @message.to_json
  end

  def manager_index
    @current_sales_manager_master_publish_list = Array.new
    @current_sales_manager_sales_publish_list = Array.new
    @publish_manager_master_list = Hash.new
    @publish_manager_sales_list = Hash.new

    @current_sales = current_book_sales
    @current_sales_publish_id_list = @current_sales.publish_id_list.split(",")

    @current_sales_publish_id_companies = PublishCompany.where(
      "id in (?)",@current_sales_publish_id_list)

    if !@sales_master_right
      redirect_to login_publish_path
    end

    #render :json => @current_sales_manager_master_publish_companies.to_json

    #從當前業務的所有出版社中，找出當前業務有擔任管理員的出版社
    #並產生 current_sales_manager_master_publish_list 存放當前業務
    #所擁有最高管理權限的出版社
    @current_sales_publish_id_companies.each do |publish_company|
      if publish_company.manager_master_id_list.split(",").include?(
          @current_sales.id.to_s)
        @current_sales_manager_master_publish_list.append(publish_company)
      end
    end if !@current_sales_publish_id_companies.nil?
    #render :text => @current_sales_manager_master_publish_list.to_json
    #將出版社中的所有 master 管理員列出
    @current_sales_manager_master_publish_list.each do | publish |
      @publish_sales_list = get_sales_list(publish, "master")
      @publish_manager_master_list.merge!({publish.name => 
        BookSalesAccount.select("id,email,last_name").where(
          "id in (?)",@publish_sales_list).where(
          "id <> ?",@current_sales.id)})
    end if !@current_sales_manager_master_publish_list.nil?
    #render :text => @publish_manager_master_list.to_json



   # render :json => @publish_manager_master_list.to_json
    #sale manager 清單

    @current_sales_manager_master_publish_list.each do | publish |
      @publish_sales_list = get_sales_list(publish, "normal")
      @publish_manager_sales_list.merge!({publish.name =>
        BookSalesAccount.select("id,email,last_name",).where("id in (?)",
          @publish_sales_list)})
    end if !@current_sales_manager_master_publish_list.nil?
    #render :json => @publish_manager_master_list.to_json

  end

  def manager_master_list_remove
    @message = Hash.new
    @publish = PublishCompany.find_by(:name => params[:publish_name])
    @publish_id_list_arr = @publish.manager_master_id_list.split(",")
    if @publish_id_list_arr.include?(params[:id])
      #if @publish_id_list_arr.include?(current_book_sales.id.to_s)
      if @sales_master_right
        @publish_id_list_arr.delete(params[:id])
        @publish.manager_master_id_list = @publish_id_list_arr.join(",")
        if @publish.save
          @message[:result] = true
        else
          @message[:result] = false
          @message[:error_message] = I18n.t("error_info.destroy_error")
        end
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.sales_right_error")
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.destroy_error")
    end
    render :json => @message.to_json
  end

  def manager_sales_list_remove
    @message = Hash.new
    @publish = PublishCompany.find_by(:name => params[:publish_name])
    @publish_id_list_arr = @publish.manager_sales_id_list.split(",")
    if @publish_id_list_arr.include?(params[:id])
      if @sales_master_right
        @publish_id_list_arr.delete(params[:id])
        @publish.manager_sales_id_list = @publish_id_list_arr.join(",") 
        if @publish.save
          @message[:result] = true
        else
          @message[:result] = false
          @message[:error_message] = I18n.t("error_info.update_error")
        end
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.sales_right_error")
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.destroy_error")
    end
    render :json => @message.to_json
  end

  def manager_list_edit
  end

  def manager_list_add
  end

  def manager_list_remove
  end

  def sales_index
  end

  def sales_list_edit
  end

  def sales_list_add
  end

  def author_index
  end

  def author_list_edit
  end

  def author_list_add
  end

  def author_list_remove
  end

  def author_required_list
  end

  def author_required_confirm
  end

  def book_sales_account_type_index
    @book_sales_account_types = BookSalesAccountType.all
  end

  def book_sales_account_type_new
    @type = BookSalesAccountType.new
  end

  def book_sales_account_type_create
    @message = Hash.new
    @params = book_sales_account_type_create_params
    @book_sales_account_type = BookSalesAccountType.new(@params)
    if @book_sales_account_type.save
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.create_error")
    end
    render :json => @message.to_json
  end
:se
  def book_sales_account_type_edit
    @book_sales_account_type = BookSalesAccountType.find(params[:id])
  end

  def book_sales_account_type_update
    @message = Hash.new
    @params = book_sales_account_type_update_params
    @book_sales_account_type = BookSalesAccountType.find(params[:id])
    if @book_sales_account_type.update(@params)
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.update_error")
    end
    render :json => @message.to_json

  end

  def login
    @book_sales = BookSalesAccount.new
  end

  def login_create
    @message = Hash.new
    @params = book_sales_login_params
    @book_sales = BookSalesAccount.find_by(:email => @params[:email])
    if !@book_sales.nil? && @book_sales.authenticate(@params[:password])
      book_sales_sign_in(@book_sales)
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.login_error")
    end
    render :json => @message.to_json
    
    
  end

  def logout
    @message = Hash.new
    book_sales_sign_out
    @message[:result] = true
    render :json => @message.to_json
    
  end


  private

  def authen_login
    if !book_sales_signed_in?
      redirect_to login_publish_path
    end
  end

  def authen_master_right
    if book_sales_signed_in?
  
      @sales_master_right = false
      current_sales = current_book_sales
      current_sales_publish_id_list = current_sales.publish_id_list.split(",")

      current_sales_publish_id_companies = PublishCompany.where(
        "id in (?)",current_sales_publish_id_list)
  
      current_sales_publish_id_companies.each do |publish_company|
        if publish_company.manager_master_id_list.split(",").include?(
            current_sales.id.to_s)
          @sales_master_right = true
          break
        end
      end
    else
      redirect_to login_publish_path
    end
  end

  def publish_create_params
    params.require(:publish).permit(:name)
  end

  def publish_update_params
    params.require(:publish_company).permit(:name,:email,:address,:tel,
                                            :fax)
  end

  def account_create_params
    params.require(:account_create).permit(:email,:password,
      :book_sales_account_type_id, :publish_company_id)
  end
  
  def book_sales_account_type_create_params
    params.require(:publish).permit(:name)
  end
  def book_sales_account_type_update_params
    params.require(:book_sales_account_type).permit(:name)
  end
  def book_sales_login_params
    params.require(:book_sales).permit(:email,:password)
  end
    
end
