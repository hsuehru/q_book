class PublishsController < ApplicationController
  include AdministratorsHelper
  include PublishsHelper
  include AuthorsHelper
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

  def account_index
  end

  def account_new 
    @book_sales_account_types = BookSalesAccountType.all
    @publish_commapies = PublishCompany.all
    @book_sales_account = BookSalesAccount.new
  end

  def account_create
    @params = account_create_params
    @pualish_company_id = PublishCompany.find(@params[:publish_company_id])
    @params.delete(:publish_company_id)
    @book_sales_account = BookSalesAccount.new(@params)
    if
    @book_sales_account.save
    #dodododo
  end

  def manager_index
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
  end

  def login_create
  end

  def logout
  end
  private
  def publish_create_params
    params.require(:publish).permit(:name)
  end
  def publish_update_params
    params.require(:publish_company).permit(:name,:email,:address,:tel,
                                            :fax)
  end

  def account_create_params
    params.require(:account_create).permit(:email,:password,
      :book_seles_account_type_id, :publish_company_id)
  end
  
  def book_sales_account_type_create_params
    params.require(:publish).permit(:name)
  end
  def book_sales_account_type_update_params
    params.require(:book_sales_account_type).permit(:name)
  end
end
