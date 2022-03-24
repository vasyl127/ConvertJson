require_relative 'convert_json'
include ConvertJson


json = JSON.parse(File.open('q.json').read)

header_keys = head_colums array_with_rows(json)
out_array = array_with_rows json

CSV.open('test_csv.csv', 'w') do |csv|
  csv << header_keys.keys
  out_array.each do |row|
    csv << header_keys.merge(row).values
  end
end


# puts convert_json_to_csv(json)