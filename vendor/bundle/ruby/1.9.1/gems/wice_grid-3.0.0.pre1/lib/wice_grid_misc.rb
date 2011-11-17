# encoding: UTF-8
module Wice

  class << self

    @@model_validated = false

    # checks whether the class is a valid storage for saved queries
    def validate_query_model(query_store_model)  #:nodoc:
      unless query_store_model.respond_to?(:list)
        raise ::Wice::WiceGridArgumentError.new("Model for saving queries #{query_store_model.class.name} is invalid - there is no class method #list defined")
      end
      arit = query_store_model.method(:list).arity
      unless arit == 2
        raise ::Wice::WiceGridArgumentError.new("Method list in the model for saving queries #{query_store_model.class.name} has wrong arity - it should be 2 instead of #{arit}")
      end
      @@model_validated = true
    end

    # Retrieves and constantizes (if needed ) the Query Store model
    def get_query_store_model #:nodoc:

      query_store_model = ::Wice::Defaults::QUERY_STORE_MODEL
      query_store_model = query_store_model.constantize if query_store_model.is_a? String
      raise ::Wice::WiceGridArgumentError.new("Defaults::QUERY_STORE_MODEL must be an ActiveRecord class or a string which can be constantized to an ActiveRecord class") unless query_store_model.kind_of? Class
      validate_query_model(query_store_model) unless @@model_validated
      query_store_model
    end

    def get_string_matching_operators(model)   #:nodoc:
      if defined?(Wice::Defaults::STRING_MATCHING_OPERATORS) && Wice::Defaults::STRING_MATCHING_OPERATORS.is_a?(Hash) &&
          str_matching_operator = Wice::Defaults::STRING_MATCHING_OPERATORS[model.connection.class.to_s]
        str_matching_operator
      else
        Wice::Defaults::STRING_MATCHING_OPERATOR
      end
    end

    def deprecated_call(old_name, new_name, opts) #:nodoc:
      if opts[old_name] && ! opts[new_name]
        opts[new_name] = opts[old_name]
        opts.delete(old_name)
        STDERR.puts "WiceGrid: Parameter :#{old_name} is deprecated, use :#{new_name} instead!"
      end
    end

    def log(message) #:nodoc:
      ActiveRecord::Base.logger.info('WiceGrid: ' + message)
    end
  end

  module MergeConditions #:nodoc:
    def self.included(base) #:nodoc:
      base.extend(ClassMethods)
    end

    module ClassMethods #:nodoc:
      def merge_conditions(*conditions) #:nodoc:
        segments = []

        conditions.each do |condition|
          unless condition.blank?
            sql = sanitize_sql(condition)
            segments << sql unless sql.blank?
          end
        end

        "(#{segments.join(') AND (')})" unless segments.empty?
      end
    end
  end


  module WiceGridNlMessageProvider #:nodoc:
    class << self

      def get_message(key) #:nodoc:
        translated = I18n.t(key.to_s.downcase, :scope => 'wice_grid')
      end

    end
  end

  module Defaults  #:nodoc:
  end

  module ExceptionsMixin  #:nodoc:
    def initialize(str)  #:nodoc:
      super("WiceGrid: " + str)
    end
  end
  class WiceGridArgumentError < ArgumentError #:nodoc:
    include ExceptionsMixin
  end
  class WiceGridException < Exception #:nodoc:
    include ExceptionsMixin
  end
end