require_relative 'convert_json'

module Convertor

  include ConvertJson

  def convert_json_to_csv(json)
    ConvertJson::json_to_csv(json)
  end

end
