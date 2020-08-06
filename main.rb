require 'csv'
require 'date'
#temp
require 'pry'

require File.expand_path('lib/modifier',File.dirname(__FILE__))
require File.expand_path('lib/csv_helper',File.dirname(__FILE__))


def latest(name)
  files = Dir["#{ ENV["HOME"] }/workspace/*#{name}*.txt"]
  files.sort_by! do |file|
    last_date = /\d+-\d+-\d+_[[:alpha:]]+\.txt$/.match file

    last_date = last_date.to_s.match /\d+-\d+-\d+/

    date = DateTime.parse(last_date.to_s)
    date
  end
  throw RuntimeError if files.empty?

  files.last
end
  

def sort(file)
  output = "#{file}.sorted"
  content_as_table = CsvHelper.parse(file)
  headers = content_as_table.headers
  index_of_key = headers.index('Clicks')
  content = content_as_table.sort_by { |a| -a[index_of_key].to_i }
  CsvHelper.write(content, headers, output)
  return output
end

modified = input = latest('project_2012-07-27_2012-10-10_performancedata')
modification_factor = 1
cancellaction_factor = 0.4
modifier = Modifier.new(modification_factor, cancellaction_factor)
modifier.modify(modified, sort(input))

puts "DONE modifying"