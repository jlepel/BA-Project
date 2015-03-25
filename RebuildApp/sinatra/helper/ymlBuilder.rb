require 'rubygems'
require 'sinatra'
require 'yaml'

class YmlBuilder

  
  # @param [String] file_name for Yaml file
  def initialize(file_name)
    reader = ConfigReader.new
    @config_input = reader.get_yaml_config_values
    @filename = file_name
  end

  public
  # @return [String] Shows yml contect line by line
  def show_file_content
    file = File.open(@filename, 'rb')
    file.read
  end

  private
  # @param [Array] items_to_install; an arraylist with all program items
  def build_yaml_body_section(items_to_install)
    {
        'tasks' =>
            [{
                 'name' => 'General | Install required packages.',
                 'action' => 'apt pkg={{ item }} state=installed',
                 'tags' => 'common',
                 'with_items' => items_to_install
             }]
    }
  end

  private
  # @param [Array] header_from_file
  # @param [Array] body_information
  def build_complete_yaml_file(header_from_file, body_information)
    [header_from_file.merge!(body_information)]
  end

  public
  # @param [Array] program_list
  def build_yml_file(program_list)
    body = build_yaml_body_section(program_list)
    File.open(@filename, 'w') { |f|
      f.write(build_complete_yaml_file(@config_input, body).to_yaml)
    }
  end

  public
  # @return [String] yml filename
  def get_filename
    @filename
  end

end


