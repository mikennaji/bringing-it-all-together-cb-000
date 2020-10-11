require_relative "../config/environment.rb"

class Dog

attr_accessor :name, :breed
attr_reader :id


def initialize(id: nil,name:,breed:)


    @name = name
    @breed = breed

  end


def self.create_table
  sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
      SQL
  DB[:conn].execute(sql)
end


def self.drop_table
  sql = <<-SQL
    DROP TABLE IF EXISTS dogs
  SQL
  DB[:conn].execute(sql)
end

def save
  sql = <<-SQL
    INSERT INTO dogs(name,breed) VALUES (?,?)
  SQL
  DB[:conn].execute(sql,self.name,self.breed)
  @id = DB[:conn].execute("SELECT last_insert_rowid();")[0][0]
  self

end

def self.create(attributes)
    new_dog = Dog.new(name:"",breed: "")
    attributes.each {|key, value| new_dog.send(("#{key}="), value)}
    new_dog.save
    new_dog
end

def self.new_from_db(row)
  new_song = self.new(id: row[0],name: row[1],grade: row[2])


end


def self.find_by_id(id)
  sql = <<-SQL
      SELECT * FROM dogs WHERE id = ?
      SQL
  self.new_from_db(DB[:conn].execute(sql,id)[0])


end


end
