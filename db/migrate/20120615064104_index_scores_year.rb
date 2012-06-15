class IndexScoresYear < ActiveRecord::Migration
  def up
    add_index :scores, [:school_id, :year]
  end

  def down
    remove_index :scores, [:school_id, :year]
  end
end
