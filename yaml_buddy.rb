require 'yaml'
# Module that can be included (mixinrequire 'TsvBuddy'
module YamlBuddy
  def take_yaml(yaml)
    @data = YAML.safe_load(yaml)
  end

  def to_yaml
    @data.to_yaml
  end
end
