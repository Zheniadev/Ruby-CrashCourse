require 'minitest/autorun'
require 'minitest/reporters'
require_relative 'Homework1.rb' 

Minitest::Reporters.use! Minitest::Reporters::HtmlReporter.new

class StudentTest < Minitest::Test
  def setup
    @student1 = Student.new("Nazarenko", "Max", "2006-11-17")
    @student2 = Student.new("Ivanova", "Anna", "2005-05-20")
    @student3 = Student.new("Petrov", "Petr", "2004-02-15")

    # Добавляем студентов в класс
    Student.add_student(@student1)
    Student.add_student(@student2)
    Student.add_student(@student3)
  end
  
  def teardown
    # Очищаем список студентов после каждого теста
    Student.class_variable_set(:@@students, [])
  end
  
  def test_calculate_age
    assert_equal 17, @student1.calculate_age
    assert_equal 19, @student2.calculate_age
    assert_equal 20, @student3.calculate_age
  end

  def test_add_student
    # Проверяем добавление студента, который уже есть
    assert_output(/Студент с такими параметрами уже существует/) { Student.add_student(@student1) }
  end

  def test_remove_student
    assert_output(/Студент Petr Petrov успешно удален./) { Student.remove_student("Petrov", "Petr", "2004-02-15") }
    assert_output(/Студент с такими параметрами отсутствует/) { Student.remove_student("Petrov", "Petr", "2004-02-15") }
  end

  def test_get_students_by_age
    # Убедимся, что в списке студентов есть нужные для проверки
    assert_output(/Студенты с возрастом '17':/) { Student.get_students_by_age(17) }
    assert_output(/Студенты с возрастом '21' не найдены./) { Student.get_students_by_age(21) }
  end

  def test_get_students_by_name
    assert_output(/Студенты с именем 'Max':/) { Student.get_students_by_name("Max") }
    assert_output(/Студенты с именем 'Olga' не найдены./) { Student.get_students_by_name("Olga") }
  end

  def test_all_students
    assert_equal [@student1, @student2, @student3], Student.all_students
  end
end
