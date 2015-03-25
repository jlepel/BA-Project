require 'rubygems'
require 'sinatra'
require './start.rb'
require 'sidekiq/web'

#require File.expand_path '../start.rb', __FILE__

use Rack::ShowExceptions
run Rack::URLMap.new('/' => Sinatra::Application, '/sidekiq' => Sidekiq::Web)

