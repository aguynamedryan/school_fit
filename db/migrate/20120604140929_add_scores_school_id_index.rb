class AddScoresSchoolIdIndex < ActiveRecord::Migration
  def up
    add_index :scores, :school_id
  end

  def down
    remove_index :scores, :school_id
  end
end
