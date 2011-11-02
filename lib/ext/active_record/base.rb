module ActiveRecord
  class Base

    def to_csv(options = Hash.new)
      fields = fields_for_csv_from_options options
      engine = RUBY_VERSION < "1.9" ? FCSV : CSV
      engine.generate do |csv|
        row = []
        fields.each { |attr| row << self.send(attr) }
        csv << row
      end
    end

    def fields_for_csv_from_options(options = Hash.new)
      defaults  = Hash.new
      fields    = Array.new
      [:only, :except, :methods].each do |key|
        defaults[key] = Array.new
      end
      defaults.merge! options
      if defaults[:only].any?
        fields = defaults[:only]
      elsif defaults[:except].any?
        fields = attributes.keys - defaults[:except]
      elsif defaults[:only].empty? and defaults[:except].empty?
        fields = attributes.keys
      end
      fields + defaults[:methods]
    end

  end
end
