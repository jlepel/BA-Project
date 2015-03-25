require 'rubygems'
require 'sinatra'
require 'fileutils'

class Vagrant

  LOGFILE = 'vagrant_log.txt'
  VAGRANTFILE_NAME = 'Vagrantfile'
  attr_reader :file_exists


  def initialize(installation_folder, yaml_file_name)
    @file_exists = false
    @installation_folder = installation_folder
    @yaml_file_name = yaml_file_name
  end

  def startup
    system('vagrant up >> ' + LOGFILE)
  end

  def login
    system('vagrant ssh >> ' + LOGFILE)
  end

  def destory
    system('vagrant destory >> ' + LOGFILE)
  end

  def logfile
    File.read(@installation_folder + '/' + VAGRANTFILE_NAME)
  end


  def write_vagrantfile(installation_folder)
    reader = ConfigReader.new
    vagrant_config = reader.get_vagrant_config_values

    write_option = 'w'
    installpath = installation_folder + '/' + VAGRANTFILE_NAME

    if File.exist?(VAGRANTFILE_NAME)
      File.delete(VAGRANTFILE_NAME)
    end

    open(installpath, write_option) { |i|
      i.write("Vagrant.configure(\"2\") do |conf|\n")
      vagrant_config.each do |key, value|
        if key == 'conf.vm.box'
          i.write("\t" + key + ' = ' + value + "\n")
        end
        if key == 'conf.vm.box_url'
          i.write("\t" + key + ' = ' + value + "\n")
        end

        if key == 'conf.vm.networkip'
          i.write("\t" + 'conf.vm.network :private_network, ip: ' + value + "\n" + "\n")
        end

      end
      i.write("\t" + 'conf.vm.provision :ansible do |ansible|' + "\n")
      i.write("\t" + "\t" + 'ansible.playbook = "' + @yaml_file_name + '"' + "\n")
      i.write("\t" + 'end' + "\n")
      i.write('end')

    }
    FileUtils.cd(installation_folder) { @file_exists = File.exist?(VAGRANTFILE_NAME) }
    file_created?
  end

  def installation_folder
    @installation_folder
  end

  # @return [Boolean] true if the vagrantfile is created
  def file_created?
    @file_exists
  end


  # @return [String] the name of the vagrantfile
  def vagrantfile_name?
    VAGRANTFILE_NAME
  end


end