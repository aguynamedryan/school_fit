class MapController < ApplicationController
  def index
    @top_schools = School.find(Score.order('value desc').find_all_by_year(2011).slice(0,10).map(&:school_id)).to_a.sort_by { |s| s.fit_score }.reverse
  end
end
