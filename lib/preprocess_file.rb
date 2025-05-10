# lib/preprocess_file.rb
class PreprocessFile
  def self.generate_index(input_file, output_file)
    File.open(input_file, "r") do |infile|
      File.open(output_file, "w") do |outfile|
        byte_offset = 0
        line_number = 0
        while (line = infile.gets)
          outfile.puts byte_offset
          byte_offset += line.bytesize
          line_number += 1
        end
        puts "Processed #{line_number} lines. Index saved to #{output_file}"
      end
    end
  rescue Errno::ENOENT
    puts "Error: Input file '#{input_file}' not found."
  end

  def self.get_line(file_path, index, offsets_path)
    offsets = File.readlines(offsets_path).map(&:to_i)
    if index >= 0 && index < offsets.length
      offset = offsets[index]
      File.open(file_path, "r") do |file|
        file.seek(offset)
        file.readline.chomp
      end
    else
      nil # Indicate line index out of bounds
    end
  rescue Errno::ENOENT
    puts "Error: File not found."
    nil
  end

  def self.line_count(offsets_path)
    File.readlines(offsets_path).count
  rescue Errno::ENOENT
    0
  end
end
