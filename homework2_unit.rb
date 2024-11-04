require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
require_relative 'rubyHW1.rb'

Minitest::Reporters.use! Minitest::Reporters::HtmlReporter.new

class StudentTest < Minitest::Test
  def setup
    @student1 = Student.new("Ackles", "Jensen", Date.new(2024, 1, 1))
    @student2 = Student.new("Padalecki", "Jared", Date.new(1995, 5, 15))
    @student3 = Student.new("Collins", "Misha", Date.new(1990, 3, 20))

    Student.add_student(@student1)
    Student.add_student(@student2)
    Student.add_student(@student3)
  end
  
  def teardown
    Student.class_variable_set(:@@students, [])
  end
  
  def test_calculate_age
    assert_equal @student1.calculate_age, 0 # Adjust based on actual date
    assert_equal @student2.calculate_age, 29
    assert_equal @student3.calculate_age, 34
  end

  def test_add_student
    assert_output(/Student already exists/) { Student.add_student(@student1) }
  end

  def test_remove_student
    assert_output(/Student Misha Collins removed/) { Student.remove_student(@student3) }
    assert_output(/Student not found/) { Student.remove_student(@student3) }
  end

  def test_get_students_by_age
    assert_equal [@student2], Student.get_students_by_age(29)
  end

  def test_get_students_by_name
    assert_equal [@student1], Student.get_students_by_name("Jensen")
  end

  def test_all_students
    assert_equal [@student1, @student2, @student3], Student.students
  end
end


