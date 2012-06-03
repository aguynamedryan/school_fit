class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :school
      t.integer :year
      t.float :value

      t.timestamps
    end
  end
end
