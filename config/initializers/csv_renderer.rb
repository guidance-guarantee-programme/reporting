ActionController::Renderers.add :csv do |object, options|
  filename = options.fetch(:filename, 'data.csv')
  filename << '.csv' unless filename =~ /\.csv$/
  send_data object.csv, type: Mime::CSV, disposition: "attachment; filename=#{filename}"
end
