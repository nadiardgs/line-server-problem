# lib/tasks/preprocess.rake
namespace :preprocess do
  desc "Generate line offset index for the input text file"
  task :generate => :environment do
    input_file = Rails.root.join('data', ENV['INPUT_FILE'] || 'input.txt')
    output_file = Rails.root.join('data', 'line_offsets.dat')
    PreprocessFile.generate_index(input_file.to_s, output_file.to_s)
  end
end