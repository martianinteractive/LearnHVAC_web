module Site
  def config
    conf = YAML.load_file("#{Rails.root}/config/site.yml")
    conf[Rails.env]
  end
end

include Site