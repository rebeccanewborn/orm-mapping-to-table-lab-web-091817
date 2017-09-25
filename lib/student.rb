require 'pry'
class Student
  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

   def initialize(name, grade)
     @name = name
     @grade = grade
   end

   def self.create_table
     sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)
     SQL
     DB[:conn].execute(sql)
   end

   def self.drop_table
     DB[:conn].execute("DROP TABLE students")
   end

   def save
     sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
     SQL
     DB[:conn].execute(sql, name, grade)

     sql = <<-SQL
      SELECT * FROM students WHERE name = ?
     SQL
     student = DB[:conn].execute(sql, name)
     @id = student[0][0]
   end

   def self.create(name:, grade:)
     new(name, grade).tap {|student| student.save}
   end


end
