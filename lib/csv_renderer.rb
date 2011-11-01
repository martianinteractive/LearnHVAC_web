require "action_controller"

ActionController::Renderers.add :csv do |object, options|
  columns = Array.new
  if object.is_a? Array or object.is_a? ActiveRecord::Relation
    columns = object.first.fields_for_csv_from_options options
  else
    columns = object.fields_for_csv_from_options options
  end

  csv = columns.join ','
  csv << "\n"

  if object.is_a? Array or object.is_a? ActiveRecord::Relation
    csv << object.map {|var| var.to_csv options}.join
  else
    csv << object.to_csv
  end
  send_data(csv,
    :content_type => Mime::CSV,
    :filename     => "dump.csv",
    :disposition  => "attachment",
    :status       => 200
  )
end
