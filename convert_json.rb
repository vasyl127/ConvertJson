require 'csv'
require 'json'

module ConvertJson

  def convert_json_to_csv(json)
    json_rows = array_with_rows(json)
    header_keys = head_colums(out_array)
    csv_string = CSV.generate do |csv|
      csv << header_keys.keys
      json_rows.each {|row| csv << header_keys.merge(row).values}
    end
    csv_string
  end

  def array_from(json)
    queue, next_item = [], json
    while !next_item.nil?

      return next_item if next_item.is_a? Array

      if next_item.is_a? Hash
        next_item.each do |k, v|
          queue.push next_item[k]
        end
      end

      next_item = queue.shift
    end

    return [json]
  end

  def flatten(object, path='')
    scalars = [String, Integer, Fixnum, FalseClass, TrueClass]
    columns = {}

    if [Hash, Array].include? object.class
      object.each do |k, v|
        new_columns = flatten(v, "#{path}#{k}/") if object.class == Hash
        new_columns = flatten(k, "#{path}#{k}/") if object.class == Array
        columns = columns.merge new_columns
      end

      return columns
    elsif scalars.include? object.class
        end_path = path[0, path.length - 1]
        columns[end_path] = object
        return columns
    else
      return {}
    end
  end

  def nils_to_strings(hash)
    hash.each_with_object({}) do |(k,v), object|
      case v
      when Hash
        object[k] = nils_to_strings v
      when nil
        object[k] = ''
      else
        object[k] = v
      end
    end
  end

  def array_with_rows(json)
    in_array = array_from json
    in_array.map! { |x| nils_to_strings x }
    out_array = []
    in_array.each {|row| out_array[out_array.length] = flatten row}
    out_array
  end

  def head_colums(array)
    header_keys = {}
    array.each do |row|
      row.each {|elem| header_keys[elem.first]='' unless header_keys.include?(elem)}
    end
    header_keys
  end
  
end