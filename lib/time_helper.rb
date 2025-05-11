module TimeHelper
  def get_difference_in_seconds(start_date, end_date)
    (((end_date - start_date)).to_f).round(2)
  end
end

