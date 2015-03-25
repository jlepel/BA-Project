require 'rubygems'
require 'net/ssh'
require 'sinatra'

@hostname = "141.22.32.88"
@username = "hawaiuser"
@password = "Hawai2014ad"
@cmd = "ls -al"

 begin
    ssh = Net::SSH.start(@hostname, @username, :password => @password)
    res = ssh.exec!(@cmd)
    ssh.close
    puts res
  rescue
    puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
  end