require "sidekiq"
require "sidekiq-status"
require "../helper/fileManager"

class TestWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker


  def perform
    total 3

    USER_PERMISSION = 'hawaiuser'
    GROUP_PERMISSION = 'hawaiuser'

    @folder_creation = false
    @vagrant_file_created = false


    file_mgr = FileManager.new

    file_mgr.create_installation_folder(INSTALLATION_FOLDER)

    at 1, "installationsordner angelegt"

    @folder_creation = file_mgr.install_folder_created?
    #TODO Falls Ordnererstellung nicht funktioniert; FEHLERSEITE zeiten

    vag = Vagrant.new(INSTALLATION_FOLDER, YML_FILE)

    if @folder_creation
      @vagrant_file_created  = vag.write_vagrantfile(INSTALLATION_FOLDER)
    end
    at 2

    if @vagrant_file_created
      file_mgr.move_file(YML_FILE, INSTALLATION_FOLDER)
      file_mgr.change_file_owner(INSTALLATION_FOLDER, FILE, USER_PERMISSION, GROUP_PERMISSION)
    end
    at 3

  end

end



