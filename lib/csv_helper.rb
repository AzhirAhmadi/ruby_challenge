class CsvHelper

    DEFAULT_CSV_OPTIONS = { :col_sep => "\t", :headers => :first_row }

    #read as CSV data
    def self.parse(file)
      CSV.read(file, DEFAULT_CSV_OPTIONS)
    end
  
    def self.lazy_read(file)
      Enumerator.new do |yielder|
        CSV.foreach(file, DEFAULT_CSV_OPTIONS) do |row|
          yielder.yield(row)
        end
      end
    end
  
    def self.write(content, headers, output)
      CSV.open(output, "wb", { :col_sep => "\t", :headers => :first_row, :row_sep => "\r\n" }) do |csv|
        csv << headers
        content.each do |row|
          csv << row
        end
      end
    end
end