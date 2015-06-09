module BooksHelper
  def get_all_book
    book1 = BookTableOne.all
    book_all = book1
    return book_all
  end

  def get_book_by_isbn( isbn = nil )
    if isbn.nil?
      return nil
    else
      book_table_count = get_global_var( :book_table_count )
      book_table_number = isbn.to_i % book_table_count 
      case book_table_number
      when 0
        book = BookTableOne.find_by(:isbn => isbn )
      else
        book = nil
      end
    end
    return book
  end

  def get_show_image_path_by_isbn( isbn = nil, type = nil)
    if isbn.nil? || type.nil?
      return nil
    else
      book = get_book_by_isbn( isbn )
      if book.nil?
        return nil
      else
        year = book.created_at.year
        month = book.created_at.month
        day = book.created_at.day
        upload_path = File.join("/book_image",
                                year.to_s,
                                month.to_s,
                                day.to_s,
                                isbn.to_s,
                                type)
        return upload_path
      end
    end
  end

  def get_upload_path_by_isbn( isbn = nil ,type = nil)
    #type = images || qr_code
    if isbn.nil? || type.nil?
      return nil
    else
      book = get_book_by_isbn( isbn )
      if book.nil?
        return nil
      else
        year = book.created_at.year
        month = book.created_at.month
        day = book.created_at.day
        upload_path = Rails.root.join("public",
                                      "book_image",
                                      year.to_s,
                                      month.to_s,
                                      day.to_s,
                                      isbn.to_s,
                                      type)
        return upload_path
      end
    end
  end

  def get_books_list_by_sales
  end

  def get_books_list_by_publish
  end

  def get_book_instance( book_params = nil )
    if book_params.nil?
      return nil
    else
      book_table_count = get_global_var( :book_table_count )
      book_table_number = book_params[:isbn].to_i % book_table_count
      case book_table_number
      when 0
        book_instance = BookTableOne.new(book_params)
      else
        return nil
      end
      return book_instance
    end
  end

end
