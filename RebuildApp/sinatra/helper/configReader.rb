class ConfigReader

  CONFIG_FILE = './helper/config.ini'

  YAML_REGEX = /^yaml.(\w+)\s?=\s?([a-z]+)\s*$/
  VAGRANT_REGEX = /^(conf\w*.\w*.\w*)\s*=\s*(.*)\s*$/
  GLOBAL_REGEX = /^(application\w*.\w*.\w*)\s*=\s*(.*)\s*$/

  def initialize
    @yaml_config = {}
    @vagrant_config = {}
    @global_config = {}
    read_file(CONFIG_FILE)
  end

  private
  # @param [String] line to check
  def yaml_information(line)
    yaml_match = line.match(YAML_REGEX)
    unless yaml_match.nil?
      key, elem = yaml_match.captures
      @yaml_config[key.gsub(/\s+/, '')]=elem.gsub(/\s+/, '')
    end
  end

  private
  # @param [String] line to check
  def vagrant_information(line)
    vagrant_match = line.match(VAGRANT_REGEX)
    unless vagrant_match.nil?
      key, elem = vagrant_match.captures
      @vagrant_config[key.gsub(/\s+/, '')]=elem.gsub(/\s+/, '')
    end
  end

  private
  # @param [String] line to check
  def global_information(line)
    global_match = line.match(GLOBAL_REGEX)
    unless global_match.nil?
      key, elem = global_match.captures
      @global_config[key.gsub(/\s+/, '')]=elem.gsub(/\s+/, '')
    end
  end

  private

  # @param [String] file_path to config file
  def read_file(file_path)
    File.open(file_path) { |line|
      line.each_line do |l|

        yaml_information(l)
        vagrant_information(l)
        global_information(l)

      end
    }
  end

  public
  # @return [Hash]
  def get_yaml_config_values
    @yaml_config
  end

  public
  # @return [Hash]
  def get_vagrant_config_values
    @vagrant_config
  end

  public
  # @return [Hash] 
  def get_global_config_values
    @global_config
  end


end

