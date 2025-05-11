module TimeHelper
  def get_difference_in_milliseconds(start_date, end_date)
    (((end_date - start_date) / 1000).to_f).round(4)
  end
end

