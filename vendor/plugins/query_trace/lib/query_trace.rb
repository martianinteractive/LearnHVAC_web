module QueryTrace
  def self.append_features(klass)
    super
    klass.class_eval do
      unless method_defined?(:log_info_without_trace)
        alias_method :log_info_without_trace, :sql
        alias_method :sql, :log_info_with_trace
      end
    end
  end

  def log_info_with_trace(event)
    log_info_without_trace(event)
    logger.debug("\e[1m\e[35m\e[1m\e[47mCalled from:\e[0m " + clean_trace(caller[2..-2]).join("\n "))
  end

  def clean_trace(trace)
    Rails.respond_to?(:backtrace_cleaner) ?
      Rails.backtrace_cleaner.clean(trace) :
      trace
  end
end
