require_relative 'convertor'
include Convertor

json = JSON.parse(File.open('q.json').read)

puts Convertor::convert_json_to_csv(json)