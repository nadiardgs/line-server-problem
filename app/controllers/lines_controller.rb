class LinesController < ApplicationController
  include TimeHelper
  def show
    start_timestamp = Time.now.getutc
    line_index_str = params[:line_index]
    var = unless line_index_str =~ /\A\d+\z/
            render plain: "Invalid line index\n", status: 400
            return
          end

    line_index = line_index_str.to_i
    text_file_path = ENV["TEXT_FILE_TO_SERVE"] || "input.txt"
    offsets_file_path = "line_offsets.dat"

    line_count = PreprocessFile.line_count(offsets_file_path)

    if line_count == 0
      render plain: "The file is empty\n", status: 413
      return
    end

    if line_index < 0 || line_index >= line_count
      render plain: "Requested line index is beyond the end of the file\n", status: 413
      return
    end

    begin
      line = PreprocessFile.get_line(text_file_path, line_index, offsets_file_path)
      end_timestamp = Time.now.getutc
      duration = get_difference_in_seconds(start_timestamp, end_timestamp)
      Rails.logger.info "Retrieved line (inspect): #{line.inspect} in #{duration} seconds\n"
      if line
        render plain: "#{line}\n", status: 200,
               headers: { "X-Request-Time" => duration.to_s }
      else
        render plain: "Error retrieving line (nil returned)\n", status: 500
      end
    rescue => e
      Rails.logger.error "Exception in LinesController: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render plain: "Internal Server Error\n", status: 500
    end
  end
end
