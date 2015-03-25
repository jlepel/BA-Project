
require 'sucker_punch'

class LogJob
  include SuckerPunch::Worker

  def perform(event)
   puts "mach was"
  end
end
