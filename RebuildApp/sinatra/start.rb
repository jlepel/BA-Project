require 'rubygems'
require 'sinatra'
require 'fileutils'
require './helper/database.rb'
require './helper/filewriter.rb'
require './helper/ymlBuilder.rb'
require './helper/configReader.rb'
require './helper/fileManager.rb'
require './helper/vagrant.rb'
require './helper/worker'


db_handler = Database_handler.new
INSTALLATION_FOLDER = '/vagrantMachines/Bachelorprojekt/BYS'
YML_FILE = 'playbook.yml'
FILE = 'Vagrantfile'

get '/' do

  @programs = db_handler.get_all_programs
  erb :home
end

post '/' do
  db_handler.add_program(params['program'], params['command'])

  redirect '/'
end


post '/confirmation' do
  @program_voting = params['progVote']

  yml_builder = YmlBuilder.new(YML_FILE)
  yml_builder.build_yml_file(@program_voting)
  @yaml_file = yml_builder.show_file_content

  erb :yaml
end

get '/commit2' do

end

post '/commit' do

  TestWorker.perform_async

  erb :commit

end

get '/job_status/:job_id' do

end

get '/:id' do
  @program = db_handler.get_program(params[:id])

  erb :edit
end

put '/:id' do
  p = db_handler.get_program(params[:id])
  p.title = params[:title]
  p.command = params[:command]
  p.updated_at = Time.now
  p.save

  redirect '/index'
end

delete '/:id' do
  db_handler.delete_program(params[:id])

  redirect '/index'
end

get '/:id/delete' do
  @program = db_handler.get_program(params[:id])
  @title = "Confirm deletion of Program ##{params[:id]}"

  erb :delete
end




