class Score < ActiveRecord::Base
  attr_accessible :school_id, :value, :year
  belongs_to :school
end
