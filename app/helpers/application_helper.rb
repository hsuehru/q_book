module ApplicationHelper
  def get_global_var(name = nil)
    @var = Hash.new
    @var[:member_table_count] = 2
    @var[:book_table_count] = 1

    if @var[name].nil?
      return nil
    else
      return @var[name]
    end
  end
end
