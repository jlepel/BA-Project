require 'rubygems'
require 'sinatra'
require 'yaml'
require './helper/configReader.rb'


class YmlBuilder 
  
  @@config_input = ''
  @@filename= "playbook.yml"

  def show_content
	file = File.open(@@filename, "rb")
	contents = file.read
  end

  def build_yaml_body_section(itemsToInstall)
   	{
   	'tasks' => 
   	 [{
   	  'name' => 'General | Install required packages.', 
   	  'action' => 'apt pkg={{ item }} state=installed',
	  'tags' => 'common',
	  'with_items' => itemsToInstall
   	 }]
    }
  end

  def buildCompleteYaml(headerInfoFromFile, bodyInformation)
    [headerInfoFromFile.merge!(bodyInformation)]
  end

  def buildYmlFile(programList)
    body = buildYamlBodySection(programList)
    File.open(@@filename, "w") {|f| 
      f.write(buildCompleteYaml(@@configInput, body).to_yaml)
    }
  end

  def initialize
   reader = ConfigReader.new
   @@configInput = reader.getYamlConfigValues   
  end

  def getFilename()
    @@filename
  end
  
end


