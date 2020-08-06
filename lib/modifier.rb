require File.expand_path('combiner',File.dirname(__FILE__))
require File.expand_path('merger',File.dirname(__FILE__))
require File.expand_path('csv_helper',File.dirname(__FILE__))
require 'csv'
require 'date'
require 'pry'


class Modifier
  attr_accessor :lines_per_file

  def initialize(lines_per_file)
    @lines_per_file = lines_per_file
  end

  def modify(output, input, key_checker_list)
    input_enumerator = CsvHelper.lazy_read(input)
    combined = combiner(input_enumerator)
    merged = Merger.new(key_checker_list).merge(combined)

    save_to_file_with_limit_line(merged,output.gsub('.txt', ''))
  end

  def save_to_file_with_limit_line(merger, file_name)
    done = false
    file_index = 0
    while not done do
      CSV.open(file_name + "_#{file_index}.txt", "wb", { :col_sep => "\t", :headers => :first_row, :row_sep => "\r\n" }) do |csv|
        headers_written = false
        line_count = 0
        while line_count < lines_per_file
          begin
            merged = merger.next
            if not headers_written
              csv << merged.keys
              headers_written = true
              line_count +=1
            end
            csv << merged
            line_count +=1
          rescue StopIteration
            done = true
            break
          end
        end
        file_index += 1
      end
    end
  end

  private

  def combiner(input_enumerator)
    Combiner.new do |value|
      value[KEYWORD_UNIQUE_ID]
    end.combine(input_enumerator)
  end  
end
