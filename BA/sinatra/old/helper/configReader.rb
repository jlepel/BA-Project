class ConfigReader

 @@config = {}

 def initialize
  
  File.open("./helper/config.ini") do |line|
   line.each_line do |l|
    key, elem = l.match(/^(.\w+)\W+([a-z]+)\s*$/).captures
    @@config[key.gsub(/\s+/, "")]=elem.gsub(/\s+/, "")
   end
  end
  
 end

 def getConfigValues
  @@config
 end

end

