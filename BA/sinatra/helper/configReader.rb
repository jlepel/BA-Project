class ConfigReader

 @@yamlConfig = {}
 @@vagrantConfig = {}
 @@globalConfig = {}

 def initialize
  filepath = "./helper/config.ini"
  
  File.open(filepath) do |line|
   line.each_line do |l|
   		#regexp = l.match(/^(.\w+)\W+([a-z]+)\s*$/)
   		yamlregexp = l.match(/^yaml.(\w+)\s?=\s?([a-z]+)\s*$/)
   		unless yamlregexp.nil? 
    		key, elem = yamlregexp.captures
    		@@yamlConfig[key.gsub(/\s+/, "")]=elem.gsub(/\s+/, "")
    	end

    	vagrantregexp = l.match(/^(conf\w*.\w*.\w*)\s*=\s*(.*)\s*$/)
    	unless vagrantregexp.nil? 
		    key, elem = vagrantregexp.captures
    		@@vagrantConfig[key.gsub(/\s+/, "")]=elem.gsub(/\s+/, "")
    	end

      globalregexp = l.match(/^(application\w*.\w*.\w*)\s*=\s*(.*)\s*$/)
      unless globalregexp.nil? 
        key, elem = globalregexp.captures
        @@globalConfig[key.gsub(/\s+/, "")]=elem.gsub(/\s+/, "")
      end    		
	end
  end
 	printVagrantConfig()
 end
 

 def getYamlConfigValues
  @@yamlConfig
 end

 def getVagrantConfigValues
  @@vagrantConfig
 end

 def getGlobalConfigValues
  @@globalConfig
 end

 def printVagrantConfig
 	@@vagrantConfig.each do |name|
 		puts name

 	end
 end

def printYamlConfig
 	@@yamlConfig.each do |name|
 		puts name
 	end
 end

end

