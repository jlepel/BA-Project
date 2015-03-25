require 'rubygems'
require 'sinatra'
require 'sucker_punch'

class WebAppsMonitor

  include SuckerPunch::Job
  workers 4


  def perform
    test = "Hallo"
    puts test
  end

end

get '/' do
  SuckerPunch.logger = Logger.new('log.log')
  WebAppsMonitor.new.async.perform
  SuckerPunch.logger.
  puts "ende"
end