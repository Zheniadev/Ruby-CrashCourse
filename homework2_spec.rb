require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
require_relative 'rubyHW1.rb'

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::JUnitReporter.new,
  Minitest::Reporters::HtmlReporter.new(
    reports_dir: 'test/html_reports/spec',
    reports_filename: 'test_results.html',
    clean: false
  )
]

describe Student do
  before do
    Student.class_variable_set(:@@students, [])
    @student1 = Student.new('Ackles', 'Jensen', Date.new(2024, 1, 1))
    @student2 = Student.new('Padalecki', 'Jared', Date.new(1995, 5, 15))
    @student3 = Student.new('Collins', 'Misha', Date.new(1990, 3, 20))
  end

  it 'correctly initializes a student' do
    _( @student1.surname ).must_equal 'Ackles'
    _( @student1.name ).must_equal 'Jensen'
    _( @student1.date_of_birth ).must_equal Date.new(2024, 1, 1)
  end

  it 'calculates age correctly' do
    expected_age = Date.today.year - 2024
    expected_age -= 1 if Date.today < Date.new(Date.today.year, 1, 1)
    _( @student1.calculate_age ).must_equal expected_age
  end

  it 'adds a student successfully' do
    Student.add_student(@student1)
    _(Student.students.size).must_equal 1
    _(Student.students).must_include @student1
  end

  it 'prevents adding duplicate students' do
    Student.add_student(@student1)
    duplicate_student = Student.new('Ackles', 'Jensen', Date.new(2024, 1, 1))
    Student.add_student(duplicate_student)
    _(Student.students.size).must_equal 1
  end

  it 'raises an error for invalid birth dates' do
    assert_raises(ArgumentError) { Student.new('Collins', 'Misha', Date.new(1990, 3, 20)) }
  end

  it 'removes a student successfully' do
    Student.add_student(@student1)
    Student.add_student(@student2)
    Student.remove_student(@student1)
    _(Student.students).wont_include @student1
  end

  it 'returns students by name' do
    Student.add_student(@student1)
    Student.add_student(@student2)
    students_by_name = Student.get_students_by_name('Jensen')
    _(students_by_name.size).must_equal 1
    _(students_by_name).must_include @student1
  end

  it 'returns students by age' do
    Student.add_student(@student2)
    students_age = Student.get_students_by_age(@student2.calculate_age)
    _(students_age.size).must_equal 1
    _(students_age).must_include @student2
  end

  it 'returns all students' do
    Student.add_student(@student1)
    Student.add_student(@student2)
    all_students = Student.students
    _(all_students.size).must_equal 2
    _(all_students).must_include @student1
    _(all_students).must_include @student2
  end
end
