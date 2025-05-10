class LinesController < ApplicationController
  def show
    line_index_str = params[:line_index]
    unless line_index_str =~ /\A\d+\z/
      render plain: "Invalid line index\\n", status: 400
      return
    end

    line_index = line_index_str.to_i
    text_file_path = Rails.root.join("data", ENV["TEXT_FILE_TO_SERVE"] || "input.txt").to_s
    offsets_file_path = Rails.root.join("data", "line_offsets.dat").to_s

    line_count = PreprocessFile.line_count(offsets_file_path)

    if line_count == 0
      render plain: "The file is empty\n", status: 413
      return
    end

    if line_index < 0 || line_index >= line_count
      render plain: "Requested line index is beyond the end of the file\n", status: 413
      return
    end

    line = PreprocessFile.get_line(text_file_path, line_index, offsets_file_path)

    if line
      render plain: "#{line}\n", status: 200
    else
      render plain: "Error retrieving line\n", status: 500
    end
  end
end
