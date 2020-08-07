require 'csv'
require 'date'
#temp
require 'pry'

require File.expand_path('lib/modifier',File.dirname(__FILE__))
require File.expand_path('lib/csv_helper',File.dirname(__FILE__))
require File.expand_path('lib/float',File.dirname(__FILE__))
require File.expand_path('lib/string',File.dirname(__FILE__))
require File.expand_path('lib/key_checker',File.dirname(__FILE__))


def latest(name)
  files = Dir["#{ ENV['HOME'] }/workspace/*#{name}*.txt"]
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

KEYWORD_UNIQUE_ID = 'Keyword Unique ID'
LAST_VALUE_WINS = ['Account ID', 'Account Name', 'Campaign', 'Ad Group', 'Keyword', 'Keyword Type', 'Subid', 'Paused', 'Max CPC', 'Keyword Unique ID', 'ACCOUNT', 'CAMPAIGN', 'BRAND', 'BRAND+CATEGORY', 'ADGROUP', 'KEYWORD']
LAST_REAL_VALUE_WINS = ['Last Avg CPC', 'Last Avg Pos']
INT_VALUES = ['Clicks', 'Impressions', 'ACCOUNT - Clicks', 'CAMPAIGN - Clicks', 'BRAND - Clicks', 'BRAND+CATEGORY - Clicks', 'ADGROUP - Clicks', 'KEYWORD - Clicks']
FLOAT_VALUES = ['Avg CPC', 'CTR', 'Est EPC', 'newBid', 'Costs', 'Avg Pos']
COMMISSIONS = ['number of commissions']
COMMISSION_VALUE = ['Commission Value', 'ACCOUNT - Commission Value', 'CAMPAIGN - Commission Value', 'BRAND - Commission Value', 'BRAND+CATEGORY - Commission Value', 'ADGROUP - Commission Value', 'KEYWORD - Commission Value']

def key_checker_list(cancellation_factor, saleamount_factor)
  list = []
  list << (HashModifier.new LAST_VALUE_WINS, (Proc.new {|value| value.last }))
  list << (HashModifier.new LAST_REAL_VALUE_WINS, (Proc.new {|value| value.select {|v| not (v.nil? or v == 0 or v == '0' or v == '')}.last }))
  list << (HashModifier.new INT_VALUES, (Proc.new {|value| value[0].to_s }))
  list << (HashModifier.new FLOAT_VALUES, (Proc.new {|value| value[0].from_german_to_f.to_german_s }))
  list << (HashModifier.new COMMISSIONS, (Proc.new {|value| (cancellation_factor * value[0].from_german_to_f).to_german_s }))
  list << (HashModifier.new COMMISSIONS, (Proc.new {|value| (cancellation_factor * saleamount_factor * value[0].from_german_to_f).to_german_s}))
end

modified = input = latest('project_2012-07-27_2012-10-10_performancedata')
modifier = Modifier.new(120000)
modifier.modify(modified, sort(input), key_checker_list(1, 0.4))

puts 'DONE modifying'