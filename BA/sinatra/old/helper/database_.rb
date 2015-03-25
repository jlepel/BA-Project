require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/builder.db")

class Programs
  include DataMapper::Resource

  property :program_id, Serial    # An auto-increment integer key
  property :title,      String,  :length => 32,   :required => true # A varchar type string, for short strings
  property :command,    String,  :length => 32,   :required => true # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
  property :updated_at, DateTime  # A DateTime, for any date you might like.

  has n, :RelatedPrograms, :child_key => [ 'programs_id' ]
  
end

class RelatedPrograms
 include DataMapper::Resource
 
 property :programs_id,  Integer, :key => true 
 property :composed_id, Integer, :key => true 
 belongs_to :programs, 'Programs'
end


DataMapper.finalize.auto_upgrade!


def addToPrograms(title, command)
 newProgEntry = Programs.new
 newProgEntry.title = title
 newProgEntry.command = command
 newProgEntry.created_at = Time.now
 newProgEntry.updated_at = Time.now
 newProgEntry.save
end

def getCommandForProg(prog)
 #TODO
end

def getAllPrograms()
 @programs = Programs.all
end
