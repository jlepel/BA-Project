require 'rubygems'
require 'sinatra'
require './helper/configReader.rb'

class VagrantConfigBuilder
	@@vagrantConfig = ""
  @@filename = 'Vagrantfile'

	def initialize
   	 reader = ConfigReader.new
   	 @@vagrantConfig = reader.getVagrantConfigValues   
	end

	def writeVagrantfile(installationFolder) 
	
	 
	 fileswitch = 'w'
   installpath = installationFolder + "/" + @@filename

 	 if File.exist?(@@filename)
  		File.delete(@@filename)
 	 end

 	 open(installpath, fileswitch){ |i|
  		i.write("Vagrant.configure(\"2\") do |conf|\n")
  		@@vagrantConfig.each do |key, value|
  	 	 if key == "conf.vm.box"
  	 		i.write("\t" + key + " = " + value + "\n")
  	 	 end
  	 	 if key == "conf.vm.box_url"
  	 		i.write("\t" + key + " = " + value + "\n")
  	 	 end

  	 	 if key == "conf.vm.networkip"
  	 		i.write("\t" + "conf.vm.network :private_network, ip: " + value + "\n" + "\n")
  	 	 end

  		end
		  i.write("\t" + "conf.vm.provision \"ansible\" do |ansible|" + "\n")
  		i.write("\t" + "\t" + "ansible.playbook = \"playbook.yml\"" + "\n")
  		i.write("\t" + "end" + "\n")
  		i.write("end")

  	 }	
     FileUtils.cd(installationFolder) do
      @fileExists = File.exist?(@@filename)
     end
     
     @fileExists
 	end

  def getFilename()
    @@filename
  end

end

