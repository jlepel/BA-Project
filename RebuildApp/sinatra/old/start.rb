require 'rubygems'
require 'sinatra'
require 'fileutils'
require './helper/database.rb'
require './helper/filewriter.rb'
require './helper/ymlBuilder.rb'
require './helper/configReader.rb'
require './helper/fileManager.rb'
require './helper/vagrantConfigBuilder.rb'
 	
get '/' do
    @programs = getAllPrograms()
    erb :home
end

post '/' do
    addProgram(params['program'], params['command'])
    
    redirect '/'
end


post '/add' do
	addToProgram(params['prgDescription'], params['prgCommand'])	
	
    redirect '/add'
end


post '/confirmation' do
	@programVote = params['progVote']
	
	ymlBuilder = YmlBuilder.new
	ymlBuilder.buildYmlFile(@programVote)
	@yamlfile = ymlBuilder.showFileContent
	
    erb :yaml
end


post '/commit' do
    @installationFolder = "/vagrantMachines/Bachelorprojekt/BYS"
    
    @vagFileCreated = false
    fileMgr = FileManager.new
    
    fileMgr.createInstallFolder(@installationFolder)
    @folderCreation = fileMgr.installfolderCreated?
    #1 TODO Falls Ordnererstellung nicht funktioniert; FEHLERSEITE zeiten

    if(@folderCreation)
        vag = VagrantConfigBuilder.new
        @vagFileCreated  = vag.writeVagrantfile(@installationFolder)  
    end

    if (@vagFileCreated)
        fileMgr.moveFile('playbook.yml', @installationFolder)
        fileMgr.changeOwnerForFile(@installationFolder, 'Vagrantfile', 'hawaiuser', 'hawaiuser')

        #system('vagrant up >> vagUP.txt')        
    end   

erb :commit
 
end

get '/:id' do
    @program = getProgram(params[:id])
  
    erb :edit
end

put '/:id' do
    p = getProgram(params[:id])
    p.title = params[:title]
    p.command = params[:command]
    p.updated_at = Time.now
    p.save
    
    redirect '/index'
end

delete '/:id' do
    deleteProgram(params[:id])
    
    redirect '/index'
end

get '/:id/delete' do
    @program = getProgram(params[:id])
    @title = "Confirm deletion of Program ##{params[:id]}"
    
    erb :delete
end






##################################




get '/relate' do
	erb :relatePrograms
end

get '/relate/progress' do
	getAllPrograms()
	@progV = params[:progVote]
 
	erb :relationProgress
end

post '/relate/progress/finished' do
	mainProgram = params[:progVote]
	relatedChoice = params[:checkedProgs]
 
	if !relatedChoice.to_a.empty?
		relatedChoice.each do |elem|
			puts "not empty"
			addRelation(getIdForProgramm(mainProgram), getIdForProgramm(elem))
		end 
	end
 
	erb :finished
end

get '/yml' do
	ymlBuilder = YmlBuilder.new
	@yamlfile = ymlBuilder.showFileContent
	
	erb :yaml
end


get '/config' do
	getAllPrograms()
	
	erb :config 
end



get '/showAll' do
	getAllPrograms()
	
	erb :showAll
end




