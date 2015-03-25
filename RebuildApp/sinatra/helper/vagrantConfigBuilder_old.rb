require 'rubygems'
require 'sinatra'
require 'fileutils'


class VagrantConfigBuilder

  FILENAME = 'Vagrantfile'
  attr_reader :file_exists

  def initialize
    @file_exists = false
  end

  # @param [String] installation_folder where the vagrantfile will be created
  # @return [Boolean] True if the file has been placed
  def write_vagrantfile(installation_folder)
    reader = ConfigReader.new
    vagrant_config = reader.get_vagrant_config_values

    write_option = 'w'
    installpath = installation_folder + '/' + FILENAME

    if File.exist?(FILENAME)
      File.delete(FILENAME)
    end

    open(installpath, write_option) { |i|
      i.write("Vagrant.configure(\"2\") do |conf|\n")
      vagrant_config.each do |key, value|
        if key == 'conf.vm.box'
          i.write("\t" + key +  ' = '  + value + "\n")
        end
        if key == 'conf.vm.box_url'
          i.write("\t" + key + ' = ' + value + "\n")
        end

        if key == 'conf.vm.networkip'
          i.write("\t" + 'conf.vm.network :private_network, ip: ' + value + "\n" + "\n")
        end

      end
      #i.write("\t" + "conf.vm.provision \"ansible\" do |ansible|" + "\n")
      #i.write("\t" + "\t" + "ansible.playbook = \"playbook.yml\"" + "\n")
      #i.write("\t" + "end" + "\n")
      i.write('end')

    }
    FileUtils.cd(installation_folder) { @file_exists = File.exist?(FILENAME) }
    file_created?
  end

  # @return [Boolean] true if the vagrantfile is created
  def file_created?
    @file_exists
  end


  # @return [String] the name of the vagrantfile
  def get_filename
    FILENAME
  end


end

