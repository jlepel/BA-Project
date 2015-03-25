require 'rubygems'
require 'fileutils'
require 'sinatra'

class FileManager

	@folderCreation = false
    @folderPermission = false

	def createInstallFolder(installpath)
		FileUtils.cd("/") do
        if (File.directory?(installpath))
            @folderCreation = true
	        @folderPermissions = true
        else  
            createdFolder = createFolder(installpath)
            unless createdFolder.nil?
                @folderCreation = true
                @folderPermission = changeFolderPermission(installpath, 0777)
            end
        end
    	end
	end


	def createFolder(folderName)
    	unless File.directory?(folderName)
        	   FileUtils.mkdir_p folderName, :verbose => true
    	end
	end

	def installfolderCreated?
		@folderCreation
	end

	def installfolderpermissions?
		@folderPermission
	end

	def moveFile(src, dest)
		FileUtils.mv(src, dest)
	end

	def changeFilePermission(path, file, permissionCode)
		FileUtils.chmod(permissionCode, path + "/" + file)
	end

	def changeFolderPermission(path, permissionCode)
		FileUtils.chmod(permissionCode, path)
	end

	def changeOwnerForFile(path, file, user, group)
		FileUtils.cd(path) do
        	FileUtils.chown(user, group, file)
    	end
	end


end