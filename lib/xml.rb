require 'builder'

module Xml #:nodoc:

  def to_xml(options = {})
    options[:indent] ||= 2
    builder = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    builder.instruct! unless options[:skip_instruct]

    builder.tag!(_type) do
      unless options[:skip_internals]
        builder.internal_mongo_document_id _id
        builder.internal_mongo_document_type _type
      end

      fields.each_value do |field|
        serialize_field(field.name, self.send(field.name), field.type, options) if field.accessible?
      end
    end
  end

  private
    def serialize_field(name = nil, value = nil, type = nil, options = {})
      return unless name
      builder = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])

      case value
        when ::Hash
          value.to_xml(options.merge({ :root => name, :skip_instruct => true }))
        when ::Array
          builder.tag! name, :type => "Array" do
            value.each { |v| serialize_field('value', v, nil, options) }
          end
        else
          type ? builder.tag!(name, value, :type => type) : builder.tag!(name, value)
      end
    end

end
