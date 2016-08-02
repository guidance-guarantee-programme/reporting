require 'csv'

if ENV.key?('RESET_COSTS').blank?
  puts '#####################'
  puts 'Skipping `Cost.delete_all`'
  puts 'If you want to reload all mappings, please run `RESET_COSTS=true bundle exec rake db:seed`'
else
  Cost.delete_all
end

class CostImporter
  MONTH_ROW = 4
  FORECAST_FLAG = 3
  NAME_COLUMN = 0

  def initialize(filename:)
    @filename = filename
  end

  def import
    data.each do |row|
      cost_item = CostItem.find_by(name: row[NAME_COLUMN])
      next unless cost_item

      row_data = headers.zip(row)

      row_data.each do |(month, forecast_flag), value|
        next unless month =~ /[A-Za-z]{3}-\d{2}/

        value = value&.gsub(/[-,]/, '').to_i
        Cost.find_or_create_by!(
          cost_item: cost_item,
          value_delta: value,
          forecast: forecast_flag == 'Forecast',
          user: User.first,
          month: Date.parse('1-' + month).strftime('%Y-%m')
        ) if value != 0
      end
    end
  end

  def data
    @data ||= CSV.read(@filename).to_a
  end

  def headers
    @headers ||= @data[MONTH_ROW].zip data[FORECAST_FLAG]
  end
end

if ENV['COSTS_FILENAME'].present? && File.exist?(ENV['COSTS_FILENAME'])
  CostImporter.new(filename: ENV['COSTS_FILENAME']).import
else
  puts '#####################'
  puts 'Skipping Cost imports'
  puts 'If you want to import a costs file, please run `COSTS_FILENAME=<path to seed file> bundle exec rake db:seed`'
end
