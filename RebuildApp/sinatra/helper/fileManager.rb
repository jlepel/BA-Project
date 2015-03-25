require 'rubygems'
require 'fileutils'
require 'sinatra'

class FileManager

  attr_reader :folder_creation
  attr_reader :folder_permission
  INSTALL_FOLDER_PERMISSIONS = 0777

  def initialize
    @folder_creation = false
    @folder_permission = false
  end

  # @param [String] install_path for the virtual machine
  # @return [Boolean] returns true when the folder is created
  def create_installation_folder(install_path)
    FileUtils.cd('/') do
      if File.directory?(install_path)
        @folder_creation = true
        @folder_permission = true
      else
        created_folder = create_folder(install_path)
        unless created_folder.nil?
          @folder_creation = true
          @folder_permission = change_folder_permission(install_path, INSTALL_FOLDER_PERMISSIONS)
        end
      end
    end
    install_folder_created?
  end


  # @param [String] folder_name
  # @return [String] returns the name of the folder
  def create_folder(folder_name)
    unless File.directory?(folder_name)
      FileUtils.mkdir_p folder_name, :verbose => true
    end
  end

  # @return [Boolean]
  def install_folder_created?
    folder_creation
  end

  # @return [Boolean]
  def install_folder_permission_set?
    folder_permission
  end

  # @param [String] src; Filepath incl Filename
  # @param [String] dest; Destination path
  # @return [Integer] returns a 0 when successful
  def move_file(src, dest)
    FileUtils.mv(src, dest)
  end

  # @param [String] path to file
  # @param [String] file to change
  # @param [Integer] permission_code; for example 0777
  # @return [String] returns the name of the file
  def change_file_permission(path, file, permission_code)
    FileUtils.chmod(permission_code, "#{path}/#{file}") #TODO ggf ändern!
  end

  # @param [String] path inlc folder
  # @param [Integer] permission_code; for example 0777
  # @return [String] returns the name of the file
  def change_folder_permission(path, permission_code)
    FileUtils.chmod(permission_code, path)
  end

  # @param [String] path
  # @param [String] file
  # @param [String] user
  # @param [String] group
  # @return [String] returns the name of the file
  def change_file_owner(path, file, user, group)
    FileUtils.cd(path) do
      FileUtils.chown(user, group, file)
    end
  end



end