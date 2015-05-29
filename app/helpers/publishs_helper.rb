module PublishsHelper
  def book_sales_sign_in(book_sales)
    session[:session_token] = book_sales.web_session_id
    session[:login_type]="book_sales"
    @current_book_sales = book_sales
  end

  def book_sales_signed_in?
    !current_book_sales.nil?
  end

  def current_book_sales
    @current_book_sales ||= BookSalesAccount.find_by(
      :web_session_id => session[:session_token])
  end

  def current_book_sales?(book_sales)
    current_book_sales == book_sales
  end
  def book_sales_sign_out
    @current_book_sales = nil
    session.delete(:session_token)
    session.delete(:login_type)
  end

  def list_to_i(list)
    list_to_i_result = list.split(",").map do |i|
                          i.to_i
                        end
    return list_to_i_result
  end

  def get_sales_list( publish_company, type)
    case type
      when "master"
        publish_sales_id_list = list_to_i( publish_company.manager_master_id_list )
      when "normal"
        publish_sales_id_list = list_to_i( publish_company.manager_sales_id_list )
      when "sales"
        publish_sales_id_list = list_to_i( publish_company.sales_id_list )
      return publish_sales_id_list
    end
  end

  def append_to_publish_id_list( publish_company, sales_account_type_id,
        book_sales)
    case sales_account_type_id.to_s
      when BookSalesAccountType.find_by(:name => "master").id.to_s
        if publish_company.manager_master_id_list.nil?
          publish_company.manager_master_id_list = book_sales.id
        else
          id_list = publish_company.manager_master_id_list.split(",")
          id_list.append(book_sales.id.to_s)
          id_list.uniq!
          publish_company.manager_master_id_list = id_list.join(",")
        end
      when BookSalesAccountType.find_by(:name => "normal").id.to_s
        if publish_company.manager_sales_id_list.nil?
          publish_company.manager_sales_id_list = book_sales.id
        else
          id_list = publish_company.manager_sales_id_list.split(",")
          id_list.append(book_sales.id.to_s)
          id_list.uniq!
          publish_company.manager_sales_id_list = id_list.join(",")
        end
      when BookSalesAccountType.find_by(:name => "sales").id.to_s
        if publish_company.sales_id_list.nil?
          publish_company.sales_id_list = book_sales.id
        else
          id_list = publish_company.sales_id_list.split(",")
          id_list.append(book_sales.id.to_s)
          id_list.uniq!
          publish_company.sales_id_list = id_list.join(",")
        end
      else
        return nil
    end
    return publish_company
  end 
    
end
