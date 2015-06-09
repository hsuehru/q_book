class BooksController < ApplicationController
  include ApplicationHelper
  include PublishsHelper
  include AdministratorsHelper
  include BooksHelper
  before_action :authen_right
  before_action :authen_login
  def index
  #render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    @book_list = get_all_book
    
  end

  def new
    @current_sales = current_book_sales
    @current_sales_publish_list = @current_sales.publish_id_list.split(",")
    @current_sales_manager_publish_list = PublishCompany.where(
      "id in (?)",@current_sales_publish_list) 
    @book_series_list = BookSeries.where("publish_company_id in (?)",
      @current_sales_publish_list)
    @languages = Language.all
    @categories = Category.all
    @category_items = CategoryItem.where(
      :category_id => @categories.first.id)
    @classification_types = ClassificationType.all
  end

  def create
    @message = Hash.new
    @params = book_create_params
    #@book_table_count = get_global_var( :book_table_count )
    
    @book = get_book_instance(@params)

    if @book.save
      @message[:result] = true
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.create_error")
    end


    render :json => @message.to_json
  end

  def edit
    @current_sales = current_book_sales
    @book = get_book_by_isbn( params[:isbn] )
    @current_sales_manager_publish_list = PublishCompany.where(
      "id in (?)",@current_sales.publish_id_list)
    @book_series_list = BookSeries.where("publish_company_id in (?)",
      @current_sales.publish_id_list)
    @languages = Language.all
    @categories = Category.all
    @category_items = CategoryItem.where(
      :category_id => @categories.first.id)
    @classification_types = ClassificationType.all
    #render :json => @book.to_json
  end

  def update
    @message = Hash.new
    @params = book_update_params
    @book = get_book_by_isbn(@params[:isbn])
    if @book.update(@params)
      @message[:result] = true 
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.update_error")
    end
      
    render :json => @message.to_json
    
  end

  def upload_file_new
    @isbn = params[:isbn]
    @book = get_book_by_isbn(@isbn)

  end

  def upload_file_create
    require 'fileutils'
    @book_table_count = get_global_var("book_table_count")
    @params = upload_file_create_params
    @isbn = @params[:isbn]
    #render :json => @params[:file].original_filename
    @files = params[:file]
    @upload_path = get_upload_path_by_isbn(@isbn,"images")
    if !File.directory?(@upload_path)
      FileUtils.mkdir_p(@upload_path)
    end
    i=1
    @files.each do |file|
      @extension = File.extname(file.original_filename)
      @path = File.join(@upload_path,i.to_s+@extension.to_s)
      File.open(@path,"wb"){|f|
        f.write(file.read)
      }
      i = i + 1
    end
      
  end

  def upload_file_edit
  end

  def upload_file_list
    @isbn = params[:isbn]
    @book = get_book_by_isbn(@isbn)
    @real_path = get_upload_path_by_isbn(@isbn,"images")
    @image_path = get_show_image_path_by_isbn(@isbn,"images")
    @file_list = Dir.entries(@real_path)
    @file_list.delete(".")
    @file_list.delete("..")
  end

  def download_qr_code
    #@image_image_pair
    require 'fileutils'
    @message = Hash.new
    @isbn = params[:isbn]
    @image_path = get_upload_path_by_isbn(@isbn,"images")
    @qr_code_path = get_upload_path_by_isbn(@isbn,"qr_code")

    if !File.directory?(@qr_code_path)
      FileUtils.mkdir_p(@qr_code_path)
    end

    if File.directory?(@image_path)
      @file_list = Dir.entries(@image_path).sort
      @file_list.delete(".")
      @file_list.delete("..")
      @file_list.each do |file|

        @extension = File.extname(file)
        @file_name = File.basename(file,@extension)
        @qr_image_pair = {:isbn => @isbn, :image => file}
        @qr = RQRCode::QRCode.new(@qr_image_pair.to_json.to_s,
          :size => 8,:level => :h)
        @png = @qr.to_img
        @png.resize(200,200).save(File.join(
          @qr_code_path,@file_name+".png"))
      end
      
      require 'rubygems'
      require 'zip'
      @zip_save_folder = "./public"
      @input_filenames =  Dir.entries(@qr_code_path)
      @input_filenames.delete(".")
      @input_filenames.delete("..")
  
      @zipfile_name = "./public/" + @isbn + "_qr_code.zip"
      if File.exist?(@zipfile_name)
        FileUtils.rm(@zipfile_name)
      end
  
      Zip::File.open(@zipfile_name, Zip::File::CREATE) do |zipfile|
        @input_filenames.each do |filename|
          zipfile.add(filename,
            File.join(@qr_code_path,filename))
        end
      #zipfile.get_output_stream("myFile") { |os| os.write "myFile contains just this" }
      end
      send_file @zipfile_name

      @message[:result] = true

      
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.download_error")
    end
   # @qr = RQRCode::QRCode.new("QQQQ", :size => 4,:level => :h)
   # @png = @qr.to_img
   # @png.resize(100,100).save("./public/test.png")
  end

  def book_series_new

    if @admin_right
      @current_sales_manager_publish_list = PublishCompany.all
      @authors_list = Author.all
    elsif @book_sales_right
      @current_sales = current_book_sales
      @publish_list = @current_sales.publish_id_list.split(",")
      @current_sales_manager_publish_list = PublishCompany.where(
        "id in (?)", @publish_list)
    end 
  end

  def book_series_create
    @message = Hash.new
    @params = book_series_new_params
    @publish_company = PublishCompany.find(@params[:publish_company_id])
    if !@publish_company.nil?
      @book_series = @publish_company.book_series.build(
        :name => @params[:name])
      if @book_series.save
        @message[:result] = true
      else
        @message[:result] = false
        @message[:error_message] = I18n.t("error_info.duplicate_name_error")
      end
    else
      @message[:result] = false
      @message[:error_message] = I18n.t("error_info.publish_not_exist_error")
    end
    render :json => @message.to_json
    
  end

  def book_series_author_id_list_edit
  end
  
  def book_series_author_id_list_add
  end

  def book_series_author_id_list_remove
  end

  def get_category_item
    @message = Hash.new
    @category_id = params[:category_id]
    @category_items = CategoryItem.select("id,name").where(
      :category_id => @category_id)
    if @category_items.nil?
      @message[:result] = false
      @message[:error_message] =  I18n.t("error_info.api_error")
      render :json => @message.to_json
    else
      render :json => @category_items.to_json
    end
    
  end

  private
  def authen_right
    @admin_right = session[:login_type] == "admin"? true:false
    @book_sales_right = session[:login_type] == "book_sales"? true:false
  end

  def authen_login
    if book_sales_signed_in? ||
      admin_signed_in?
    else
      redirect_to login_publish_path
    end
  end


  def book_series_new_params
    params.require(:book_series_new).permit(:name,:publish_company_id) 
  end
  def book_create_params
    params.require(:book_new).permit(:name,
                                    :isbn,
                                    :graph_count,
                                    :page_number,
                                    :publish_company_id,
                                    :book_series_id,
                                    :language_id,
                                    :category_id,
                                    :category_item_id,
                                    :classification_type_id,
                                    :author_name_list,
                                    :translator_name_list,
                                    :publish_date,
                                    :content_introduction)
  end
  def book_update_params
    params.require(:book_update).permit(:name,
                                    :isbn,
                                    :graph_count,
                                    :page_number,
                                    :publish_company_id,
                                    :book_series_id,
                                    :language_id,
                                    :category_id,
                                    :category_item_id,
                                    :classification_type_id,
                                    :author_name_list,
                                    :translator_name_list,
                                    :publish_date,
                                    :content_introduction,
                                    :active)
  end
  def upload_file_create_params
    params.require(:book_images).permit(:isbn,
                                        "file")
  end
    
end
