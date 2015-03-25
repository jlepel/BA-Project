require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/builder.db")

class Program
  include DataMapper::Resource

  property :id, Serial    # An auto-increment integer key
  property :title,      String,  :length => 255,   :required => true # A varchar type string, for short strings
  #property :description,    String,  :length => 255,   :required => true # A text block, for longer string data.
  property :command,    String,  :length => 255,   :required => true # A text block, for longer string data.
  property :created_at, DateTime  # A DateTime, for any date you might like.
  property :updated_at, DateTime  # A DateTime, for any date you might like.

  has n, :Relatedprogram
  
end

class Relatedprogram
 include DataMapper::Resource
 
 property :composed_id, Integer, :key => true 
 belongs_to :program, :key => true
end

DataMapper.finalize.auto_upgrade!

# checked
def getProgram(idOrName)
 	if(/\A[-+]?\d+\z/ === idOrName)
 	 return getProgramByID(idOrName)
	else
 	 return getProgramByName(idOrName)
	end
end

# checked
def getProgramByName(itemName)
	Program.first(:title => itemName)
end

# checked
def getProgramByID(itemID)
	Program.get(itemID)
end
# checked
def getAllPrograms()
	Program.all
end


def addProgram(title, command)
	newProgEntry = Program.new
	newProgEntry.title = title
	newProgEntry.command = command
	newProgEntry.created_at = Time.now
	newProgEntry.updated_at = Time.now
	newProgEntry.save
end

def deleteProgram(idOrName)
	if(/\A[-+]?\d+\z/ === idOrName)
	 return deleteProgramByID(idOrName)
	else
	 return deleteProgramByName(idOrName)
 	end
end

#TODO checked but with associations it doesnt work
def deleteProgramByID(itemID)
	item = getProgramByID(itemID)
	item.destroy
end

#TODO ERROR MESSAGE...BUT NO IDEA WHY
#def deleteProgramByName(Name)
#	item = getProgramByName(Name)
#	item.destroy
#end

def deleteAllPrograms()
	Program.destroy
end

def getAllRelations()
	@relation = Relatedprogram.all
end


def addRelation(programID, composeID)
	newRelation = Relatedprogram.new
	newRelation.composed_id = composeID
	newRelation.program_id = programID
	newRelation.save
end

#def getNameByID(progID)
# programTitle = ""
 
 #programID  = Program.all(:id => progID)
 #programID.each do |elem|
 #	programTitle = elem.title
 #end

 #return programTitle
#end





#def getIdForProgram(prog)
# returnValue = nil
# program  = Program.all(:title.like => prog)
 
 #program.each do |elem|
 #	returnValue = elem.id
 #end
 
 #return returnValue
#end




