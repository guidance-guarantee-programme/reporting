module ApplicationHelper
  def search_configuration_json
    ENV.fetch('SEARCH_CONFIGURATION_JSON', '[]')
  end
end
