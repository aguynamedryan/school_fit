class School < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :address, :fit_score, :name

  def grade
    return 'A' if (fit_score >= 90)
    return 'B' if (fit_score >= 80)
    return 'C' if (fit_score >= 70)
    return 'D' if (fit_score >= 60)
    return 'F'
  end
end
