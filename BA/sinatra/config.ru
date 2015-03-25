require 'rubygems'
require 'sinatra'
require './start.rb'
#require File.expand_path '../start.rb', __FILE__

use Rack::ShowExceptions
run Sinatra::Application
