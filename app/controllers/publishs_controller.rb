class PublishsController < ApplicationController
  include AdministratorsHelper
  include PublishsHelper
  include AuthorsHelper
  before_action :authen_login, :only => [:manager_index]
  before_action :authen_master_right, :only => [:manager_index,
                                                :manager_master_list_remove,
                                                :manager_sales_list_remove,
                                                :sales_index,
                                                :sales_list_add,
                                                :author_index,
                                                :author_list_edit,
                                                :author_list_add,
                                                :author_list_remove]


  before_action :authen_normal_right, :only => [:sales_index,
                                                :sales_list_remove,
                                                :sales_list_add,
                                                :author_index,
                                                :author_list_edit,
                                                :author_list_add,
                                                :author_list_remove]

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
      @publish_manager_master_list.merge!({publish => 
        BookSalesAccount.select("id,email,last_name").where(
          "id in (?)",@publish_sales_list).where(
          "id <> ?",@current_sales.id)})
    end if !@current_sales_manager_master_publish_list.nil?
    #render :text => @publish_manager_master_list.to_json



   # render :json => @publish_manager_master_list.to_json
    #sale manager 清單

    @current_sales_manager_master_publish_list.each do | publish |
      @publish_sales_list = get_sales_list(publish, "normal")
      @publish_manager_sales_list.merge!({publish =>
        BookSalesAccount.select("id,email,last_name",).where("id in (?)",
          @publish_sales_list)})
    end if !@current_sales_manager_master_publish_list.nil?
    #render :json => @publish_manager_master_list.to_json

  end

  def manager_master_list_remove
    @message = Hash.new
    @publish = PublishCompany.find(params[:publish_id])
    @publish_id_list_arr = @publish.manager_master_id_list.split(",")
    @sales = BookSalesAccount.find(params[:id])
    if @publish_id_list_arr.include?(params[:id])
      #if @publish_id_list_arr.include?(current_book_sales.id.to_s)
      if @sales_master_right
        @publish_id_list_arr.delete(params[:id])
        @publish.manager_master_id_list = @publish_id_list_arr.join(",")
        @sales_publish_id_list = @sales.publish_id_list.split(",")
        @sales_publish_id_list.delete(@publish.id.to_s)
        @sales.publish_id_list = @sales_publish_id_list.join(",")
        ActiveRecord::Base.transaction do
          if @publish.save && @sales.save

            @message[:result] = true
          else
            @message[:result] = false
            @message[:error_message] = I18n.t("error_info.destroy_error")
            raise ActiveRecord::Rollback
          end
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
    @publish = PublishCompany.find(params[:publish_id])
    @publish_id_list_arr = @publish.manager_sales_id_list.split(",")
    @sales = BookSalesAccount.find(params[:id])
    if @publish_id_list_arr.include?(params[:id])
      if @sales_master_right
        @publish_id_list_arr.delete(params[:id])
        @publish.manager_sales_id_list = @publish_id_list_arr.join(",") 
        @sales_publish_id_list = @sales.publish_id_list.split(",")
        @sales_publish_id_list.delete(@publish.id.to_s)
        @sales.publish_id_list = @sales_publish_id_list.join(",")
        ActiveRecord::Base.transaction do
          if @publish.save && @sales.save

            @message[:result] = true
          else
            @message[:result] = false
            @message[:error_message] = I18n.t("error_info.destroy_error")
            raise ActiveRecord::Rollback
          end
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
    @current_sales_manager_master_publish_list = Array.new
    @publish_manager_master_list = Hash.new
    @current_sales = current_book_sales
    @book_sales_account_types = BookSalesAccountType.where("name in (?)",["master","normal"])
    @current_sales_publish_id_list = @current_sales.publish_id_list.split(",")

    @current_sales_publish_id_companies = PublishCompany.where(
      "id in (?)",@current_sales_publish_id_list)

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
    #render :json => @current_sales_manager_master_publish_list.to_json
  end

  def manager_list_add
    @message = Hash.new
    @params = manager_list_add_params
    @sales = BookSalesAccount.find_by(:email => @params[:email])
    if !@sales.nil?
      @current_sales = current_book_sales
      @publish = PublishCompany.find(@params[:publish_company_id])
      if @publish.manager_master_id_list.split(",").include?(
          @current_sales.id.to_s)
        case @params[:book_sales_account_type_id]
        when "1"
          @publish_id_list = @publish.manager_sales_id_list.split(",")
          if @publish_id_list.include?(@sales.id.to_s)
            @message[:result] = false
            @message[:error_message] = I18n.t(
              "error_info.sales_exist_manager_sales_error")
          else
            @publish = append_to_publish_id_list(@publish, 1,@sales)
            @sales = append_to_sales_publish_id_list(@sales, @publish )
  
          end
        when "2"
          @publish_id_list = @publish.manager_master_id_list.split(",")
          if @publish_id_list.include?(@sales.id.to_s)
            @message[:result] = false
            @message[:error_message] = I18n.t(
              "error_info.sales_exist_manager_master_error")
          else
            @publish = append_to_publish_id_list(@publish, 2,@sales)
            @sales = append_to_sales_publish_id_list(@sales, @publish) 
          end
        end
        ActiveRecord::Base.transaction do
          if @publish.save && @sales.save
            @message[:result] = true
          else
            @message[:result] = false
            @message[:error_message] = I18n.t("error_info.update_error")
            raise ActiveRecord::Rollback
          end
        end
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.wrrong_identity")
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.email_nil_error")
    end
    render :json => @message.to_json
  end

  def manager_list_remove
  end

  def sales_index
    if @sales_master_right || @sales_normal_right
      @current_sales_manager_master_publish_list = Array.new
      @publish_sales_list = Hash.new
      @current_sales = current_book_sales
      @book_sales_account_types = BookSalesAccountType.where("name in (?)",["master","normal"])
      @current_sales_publish_id_list = @current_sales.publish_id_list.split(",")
  
      @current_sales_publish_id_companies = PublishCompany.where(
        "id in (?)",@current_sales_publish_id_list)

      @current_sales_publish_id_companies.each do |publish_company|
          @current_sales_manager_master_publish_list.append(publish_company)
      end
      @current_sales_manager_master_publish_list.each do |publish_company|
        @publish_sales_list.merge!({publish_company => 
          BookSalesAccount.where("id in (?)",
          publish_company.sales_id_list.split(","))})
      end
    else
      redirect_to login_publish_path
    end
  end
  def sales_list_remove
    @message = Hash.new
    @publish = PublishCompany.find(params[:publish_id])
    @book_sales = BookSalesAccount.find(params[:id])

    @publish_id_list_arr = @publish.sales_id_list.split(",")
    @publish_manager_master_list = @publish.manager_master_id_list.split(",")
    if @publish_id_list_arr.include?(params[:id])
      if @sales_master_right || @sales_normal_right
        @publish_id_list_arr.delete(params[:id])
        @publish.sales_id_list = @publish_id_list_arr.join(",") 
        @sales_publish_id_list = @book_sales.publish_id_list.split(",")
        @sales_publish_id_list.delete(params[:publish_id])
        @book_sales.publish_id_list = @sales_publish_id_list.join(",")
        ActiveRecord::Base.transaction do
          if @publish.save && @book_sales.save
            @message[:result] = true
          else
            @message[:result] = false
            @message[:error_message] = I18n.t("error_info.update_error")
            raise ActiveRecord::Rollback
          end
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

  def sales_list_edit
    @current_sales_manager_master_publish_list = Array.new
    @publish_manager_master_list = Hash.new
    @current_sales = current_book_sales
    @current_sales_publish_id_list = @current_sales.publish_id_list.split(",")

    @current_sales_publish_id_companies = PublishCompany.where(
      "id in (?)",@current_sales_publish_id_list)

    @current_sales_publish_id_companies.each do |publish_company|
      if publish_company.manager_master_id_list.split(",").include?(
          @current_sales.id.to_s)
        @current_sales_manager_master_publish_list.append(publish_company)
      end
    end
  end

  def sales_list_add
    @message = Hash.new
    @params = sales_list_add_params
    @publish = PublishCompany.find(@params[:publish_company_id])
    @sales = BookSalesAccount.find_by(:email => @params[:email])
    #render :text => @sales.to_json
    @current_sales = current_book_sales
    @publish_master_list = @publish.manager_master_id_list.split(",")
    @publish_normal_list = @publish.manager_sales_id_list.split(",")
    @publish_sales_list = @publish.sales_id_list.split(",")
    if !@sales.nil?
      if @sales_master_right || @sales_normal_right
        if !@publish_master_list.include?(@sales.id.to_s) ||
           !@publish_normal_list.include?(@sales.id.to_s)
              @publish = append_to_publish_id_list(@publish, 3,@sales)
              @sales = append_to_sales_publish_id_list(@sales, @publish )
              if !@publish_sales_list.include?(@sales.id.to_s)
                ActiveRecord::Base.transaction do
                  if @publish.save && @sales.save 
                    @message[:result] = true
                  else
                    @message[:result] = false
                    @message[:error_message] = I18n.t(
                      "error_info.update_error")
                    raise ActiveRecord::Rollback
                  end
                end
              else
                @message[:result] = false
                @message[:error_message] = I18n.t(
                  "error_info.data_exist_error")
              end
          
        else
          @message[:result] = false
          @message[:error_message] = I18n.t(
            "error_info.sales_exist_other_right_error")
  
        end
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.sales_right_error")
      end
      else
        @message[:result] = false
        @message[:error_message] = I18n.t(
          "error_info.email_not_exist_error")
    end
    render :json => @message.to_json
  end

  def author_index

    @message = Hash.new
    @current_sales = current_book_sales
    @current_sales_publish_list = @current_sales.publish_id_list.split(",")
    @publish_companies = PublishCompany.where("id in (?)",
                          @current_sales_publish_list)
    @author_list = Hash.new
    @publish_companies.each do | publish_company |
      @authors = Author.where("id in (?)", 
        publish_company.author_id_list.split(","))
      @author_list.merge!({publish_company => @authors})
    end
    
  end

  def author_list_edit
    
    @current_sales_manager_master_publish_list = Array.new
    @current_sales = current_book_sales
    @current_sales_publish_list = @current_sales.publish_id_list.split(",")
    @publish_companies = PublishCompany.where("id in (?)",
      @current_sales_publish_list)
    @publish_companies.each do |publish_company|
      @publish_master_list = publish_company.manager_master_id_list.split(",")
      @publish_normal_list = publish_company.manager_sales_id_list.split(",")
      if @publish_master_list.include?(@current_sales.id.to_s) ||
          @publish_normal_list.include?(@current_sales.id.to_s)
        @current_sales_manager_master_publish_list.append(publish_company)
      end
    end
  end

  def author_list_add
    @message = Hash.new
    @current_sales = current_book_sales
    @params = author_list_add_params
    @author = Author.find_by(:email => @params[:email])
    @publish = PublishCompany.find(@params[:publish_company_id])
    if !@author.nil? && !@publish.nil?
      @publish_author_list = @publish.author_id_list.split(",")
      if @publish_author_list.include?(@author.id.to_s)
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.data_exist_error")
      else
        @publish_author_list.append(@author.id.to_s)
        @publish.author_id_list = @publish_author_list.join(",")
        if @publish.save
          @message[:result] = true
        else
          @message[:result] = false
          @message[:error_message] = I18n.t("error_info.create_error")
        end
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.create_error")
    end
    render :json => @message.to_json
  end

  def author_list_remove
    @message = Hash.new
    @publish = PublishCompany.find(params[:publish_id])
    @author = Author.find(params[:id])
    @publish_author_list = @publish.author_id_list.split(",")
    if @sales_master_right || @sales_normal_right
      if @publish_author_list.include?(@author.id.to_s)
        @publish_author_list.delete(@author.id.to_s)
        @publish.author_id_list = @publish_author_list.join(",")
        if @publish.save
          @message[:result] = true
        else
          @message[:result] = false
          @message[:error_message] = I18n.t("error_info.update_error")
        end
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.destroy_error")
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.sales_right_error")
    end
    render :json => @message.to_json

    
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
      current_sales_publish_id_list = current_sales.publish_id_list.split(
        ",")

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

  def authen_normal_right
    if book_sales_signed_in?

      @sales_normal_right = false
      current_sales = current_book_sales
      current_sales_publish_id_list = current_sales.publish_id_list.split(
        ",")

      current_sales_publish_id_companies = PublishCompany.where(
        "id in (?)",current_sales_publish_id_list)
  
      current_sales_publish_id_companies.each do |publish_company|
        if publish_company.manager_sales_id_list.try(:split,",").try(
            :include?, current_sales.id.to_s)
          @sales_normal_right = true
          break
        end
      end
    else
      redirect_to login_publish_path
    end
  end

  def authen_sales_right
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
  def manager_list_add_params
    params.require(:manager_list_add).permit(:email,
                                             :book_sales_account_type_id,
                                             :publish_company_id)
  end

  def sales_list_add_params
    params.require(:sales_list_add).permit(:email,
                                           :publish_company_id)
  end

  def author_list_add_params
    params.require(:author_list_add).permit(:email,
                                            :publish_company_id)
  end    
end
