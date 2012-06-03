class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :grade
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
