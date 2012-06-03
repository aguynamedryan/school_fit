class JuggleSchoolColumns < ActiveRecord::Migration
  def up
    remove_column :schools, :address
    remove_column :schools, :fit_score
    add_column :schools, :cdscode, :string
    add_column :schools, :district, :string
    add_column :schools, :county, :string

    add_index :schools, :district
    add_index :schools, :cdscode
  end

  def down
  end
end
