require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id


  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
end

def self.drop_table
  sql =<<-SQL
  DROP TABLE IF EXISTS students
  SQL
  DB[:conn].execute(sql)
     end 

   def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
   end
   def save
    if self.id
      DB[:conn].execute("update students set name = ? where id = ?", @name,@id)
      DB[:conn].execute("update students set grade = ? where id = ?", @grade,@id)

    else
      DB[:conn].execute("insert into students (name,grade) values( ?,? )",@name,@grade)
      self.id= DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
end 
def self.create(name, grade)
  student = Student.new(name,  grade)
student.save
student
end

def self.new_from_db(row)
self.new( row[0], row[1],  row[2])
end

def self.find_by_name(name)
  sql = <<-SQL
SELECT * FROM students WHERE name  =?  LIMIT 1
  SQL
DB[:conn].execute(sql, name).map do |row|
  self.new_from_db(row)
end.first
end 

def update
  DB[:conn].execute("UPDATE  students  SET  name = ?  WHERE id = ?",  @name, @id)
  DB[:conn].execute("UPDATE  students  SET  grade = ?  WHERE id = ?",  @grade, @id)
end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
