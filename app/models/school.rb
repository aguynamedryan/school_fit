class School < ActiveRecord::Base
  attr_accessible :district, :county, :cdscode, :latitude, :longitude, :address, :fit_score, :name
  has_many :scores, :order => 'year DESC'

  METHODS_TO_INCLUDE = [:fit_score, :grade]

  def grade
    return 'A' if (fit_score >= 90)
    return 'B' if (fit_score >= 75)
    return 'C' if (fit_score >= 60)
    return 'D' if (fit_score >= 40)
    return 'F'
  end

  def score_values
    scores.reverse.map { |s| { :year => s.year, :value => s.value } }
  end

  def fit_score
    scores.first.value
  end

  def recommendation
    Recommendation.find_by_grade(self.grade)
  end

  def top_ten_in_district
    schools = School.find_all_by_district(district).to_a
    schools.sort_by { |s| s.fit_score }.reverse.slice(0, 10)
  end
end
