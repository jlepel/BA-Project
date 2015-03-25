require 'rubygems'
require 'sinatra'
require './helper/configReader.rb'
require 'yaml'

class YmlBuilder 
  
  #@@testItemsBody = ['php5', 'apache2', 'mysql-server', 'mysql-client','php5-mysql','php-apc','php5-xmlrpc','php-soap','php5-gd','sendmail','unzip','python-mysqldb']
  @@configInput = ''


  def showFileContent
	file = File.open("output.yml", "rb")
	contents = file.read
  end

  def buildYamlBodySection(itemsToInstall)
   
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
    File.open("output.yml", "w") {|f| 
      f.write(buildCompleteYaml(@@configInput, body).to_yaml)
    }
  end

  def initialize
   reader = ConfigReader.new
   @@configInput = reader.getConfigValues   
  end
  
end


