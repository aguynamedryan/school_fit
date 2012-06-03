require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  def test_fit_score_to_letter_grades
    assert_equal 'A', School.new(:fit_score => 90).grade
    assert_equal 'B', School.new(:fit_score => 89).grade
    assert_equal 'B', School.new(:fit_score => 80).grade
    assert_equal 'C', School.new(:fit_score => 79).grade
    assert_equal 'C', School.new(:fit_score => 70).grade
    assert_equal 'D', School.new(:fit_score => 69).grade
    assert_equal 'D', School.new(:fit_score => 60).grade
    assert_equal 'F', School.new(:fit_score => 59).grade
    assert_equal 'F', School.new(:fit_score => 0).grade
  end
end
