require "time_helper.rb"
class PreprocessFile
  include TimeHelper
  def self.generate_index(input_file, output_file)
    input_path = Rails.root.join(input_file).to_s
    output_path = Rails.root.join("data", output_file).to_s

    File.open(input_path, "r") do |infile|
      File.open(output_path, "w") do |outfile|
        byte_offset = 0
        line_number = 0

        start_timestamp = Time.now.getutc

        generate_message = "Generating file #{output_file}... This might take a few seconds.\n"
        Rails.logger.info = generate_message
        puts generate_message

        while (line = infile.gets)
          outfile.puts byte_offset
          byte_offset += line.bytesize
          line_number += 1
        end

        end_timestamp = Time.now.getutc
        duration = get_difference_in_seconds(start_timestamp, end_timestamp)

        processed_message = "File #{output_file} processed successfully #{line_number} lines
          in #{duration} seconds."
        Rails.logger.info processed_message
        puts processed_message
      end
    end
  rescue Errno::ENOENT
    puts "Error: Input file '#{input_path}' not found."
  end

  def self.get_line(file_path, index, offsets_path)
    full_file_path = Rails.root.join(file_path).to_s
    full_offsets_path = Rails.root.join("data", offsets_path).to_s
    offsets = File.readlines(full_offsets_path).map(&:to_i)
    if index >= 0 && index < offsets.length
      offset = offsets[index]
      begin
        File.open(full_file_path, "r", encoding: Encoding::ASCII_8BIT) do |file|
          file.seek(offset)
          line = file.readline.chomp
          Rails.logger.info "PreprocessFile.get_line - Read line (inspect): #{line.inspect}"
          return line
        end
      rescue EOFError
        Rails.logger.warn "EOFError encountered while reading #{full_file_path} at offset #{offset}"
        nil
      rescue => e
        Rails.logger.error "Error reading in PreprocessFile.get_line: #{e.message}"
        nil
      end
    else
      nil
    end
  rescue Errno::ENOENT
    puts "Error: File not found."
    nil
  end

  def self.line_count(offsets_path)
    full_offsets_path = Rails.root.join("data", offsets_path).to_s
    Rails.logger.info "PreprocessFile.line_count - Offsets path: #{full_offsets_path}"
    begin
      lines = File.readlines(full_offsets_path)
      Rails.logger.info "PreprocessFile.line_count - Number of lines read: #{lines.count}"
      lines.count
    rescue Errno::ENOENT
      0
    rescue => e
      Rails.logger.error "Error reading offsets file in line_count: #{e.message}"
      0
    end
  end
end
