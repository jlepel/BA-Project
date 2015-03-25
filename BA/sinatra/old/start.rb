require 'rubygems'
require 'sinatra'
require 'fileutils'
require './helper/database.rb'
require './helper/filewriter.rb'
require './helper/ymlBuilder.rb'
require './helper/configReader.rb'

 	
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
    #Checken!!!!! 
    FileUtils.cd("/") do
        
        if (File.directory?(@installationFolder))
            @folderCreation = true
        elsif  (createFolder(@installationFolder)).nil?
            @folderCreation = true
            @folderPermissions = FileUtils.chmod 0777, '/vagrantMachines/Bachelorprojekt/BYS', :verbose => true
        else
            @folderName = false
        end
    end
    #CHECKEN!!! ENDE

    FileUtils.cd("/vagrantMachines/Bachelorprojekt/BYS") do
        system 'vagrant init'
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


def createFolder(folderName)
    unless File.directory?(folderName)
        FileUtils.mkdir_p folderName, :verbose => true
    end
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




