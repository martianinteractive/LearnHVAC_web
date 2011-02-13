module Site
  def config
    @config ||= YAML.load_file("#{Rails.root}/config/site.yml")[Rails.env]
  end
end

include Site