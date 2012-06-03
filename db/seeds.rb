# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
load 'db/importit.rb'
Recommendation.create(:grade => 'A', :title => 'How to keep your Fit Score high', :description => 'recs.pdf')
Recommendation.create(:grade => 'B', :title => 'How to get that A', :description => 'recs.pdf')
Recommendation.create(:grade => 'C', :title => "Here's how other schools got to the B zone" , :description => 'recs.pdf')
Recommendation.create(:grade => 'D', :title => "Here's how other schools improved their Fit Score in the C range", :description => 'recs.pdf')
Recommendation.create(:grade => 'F', :title => "From F to Fit - A Two-Year Plan", :description => 'recs.pdf')
