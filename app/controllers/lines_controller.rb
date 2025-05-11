class LinesController < ApplicationController
  def show
    line_index_str = params[:line_index]
    unless line_index_str =~ /\A\d+\z/
      render plain: "Invalid line index", status: :bad_request
      return
    end

    line_index = line_index_str.to_i
    text_file_path = ENV['TEXT_FILE_TO_SERVE'] || 'input.txt'
    offsets_file_path = 'line_offsets.dat'

    Rails.logger.info "Requested index: #{line_index}"
    Rails.logger.info "Text file path (controller): #{Rails.root.join(text_file_path)}"
    Rails.logger.info "Offsets file path (controller): #{Rails.root.join('data', offsets_file_path)}"

    line_count = PreprocessFile.line_count(offsets_file_path)
    Rails.logger.info "Line count: #{line_count}"

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
      Rails.logger.info "Retrieved line (inspect): #{line.inspect}"
      if line
        render plain: "#{line}\n", status: 200
      else
        render plain: "Error retrieving line (nil returned)\n", status: 500
      end
    rescue => e
      Rails.logger.error "Exception in LinesController: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render plain: "Internal Server Error\n", status: :internal_server_error
    end
  end
end
