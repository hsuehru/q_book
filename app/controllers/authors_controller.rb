class AuthorsController < ApplicationController
  include AuthorsHelper
  def index
    @authors = Author.all
  end

  def new
    @author = Author.new
  end

  def create
    @message = Hash.new
    @params = author_create_params
    @author = Author.new(@params)
    if @author.save
      @message[:result] = true 
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.register_error")
    end
    render :json => @message.to_json
  end

  def edit
    @author = Author.find(params[:id])
  end

  def update
    @message = Hash.new
    @author = Author.find(params[:id])
    @params = author_update_params
    if @author.update(@params)
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("view.update_error")
    end
    render :json => @message.to_json
      
  end

  def publish_required_create
  end

  def login
    @author = Author.new
  end

  def login_create
    @message = Hash.new
    @params = author_login_params
    @author = Author.find_by(:email => @params[:email])
    if !@author.nil? && @author.authenticate(@params[:password])
      author_sign_in(@author)
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.login_error")
    end
      render :json => @message.to_json
  end

  def logout
    @message = Hash.new
    author_sign_out
    @message[:result] = true
    render :json => @message.to_json
  end
  
  def publish_required_create
  end

  private
  def author_create_params
    params.require(:author).permit(:email,:password)
  end

  def author_update_params
    params.require(:author).permit(:nickname,:password)
  end
  
  def author_login_params
    params.require(:author).permit(:email,:password)
  end
end
