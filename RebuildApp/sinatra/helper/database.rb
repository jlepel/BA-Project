require 'data_mapper'



DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/builder.db")

class Program
  include DataMapper::Resource

  property :id, Serial # An auto-increment integer key
  property :title, String, :length => 255, :required => true # A varchar type string, for short strings
  property :command, String, :length => 255, :required => true # A text block, for longer string data.
  property :created_at, DateTime # A DateTime, for any date you might like.
  property :updated_at, DateTime # A DateTime, for any date you might like.

  has n, :Relatedprogram

end

class Relatedprogram
  include DataMapper::Resource

  property :composed_id, Integer, :key => true
  belongs_to :program, :key => true
end

DataMapper.finalize.auto_upgrade!


class Database_handler
# checked
  def get_program(id_or_name)
    (/\A[-+]?\d+\z/ === id_or_name) ? get_program_by_id(id_or_name) : get_program_by_name(id_or_name)
  end

# checked
# @param [String] item_name
  def get_program_by_name(item_name)
    Program.first(:title => item_name)
  end

# checked
# @param [integer] item_id
  def get_program_by_id(item_id)
    Program.get(item_id)
  end

# checked
# @return [map]
  def get_all_programs
    Program.all
  end

# @param [Object] title

# @param [Object] command
  def add_program(title, command)
    new_prog = Program.new
    new_prog.title = title
    new_prog.command = command
    new_prog.created_at = Time.now
    new_prog.updated_at = Time.now
    new_prog.save
  end

# @param [Object] id_or_name
  def delete_program(id_or_name)
    (/\A[-+]?\d+\z/ === id_or_name) ? delete_program_by_id(id_or_name) : delete_program_by_name(id_or_name)
  end

#TODO checked but with associations it doesnt work
  def delete_program_by_id(item_id)
    item = get_program_by_id(item_id)
    item.destroy
  end

#TODO ERROR MESSAGE...BUT NO IDEA WHY
# @param [Object] name
  def delete_program_by_name(name)
  item = getProgramByName(name)
  item.destroy
end

  def delete_all_programs
    Program.destroy
  end

  def get_all_relations
    @relation = Relatedprogram.all
  end


  def add_relation(program_id, compose_id)
    new_relation = Relatedprogram.new
    new_relation.composed_id = compose_id
    new_relation.program_id = program_id
    new_relation.save
  end

end





