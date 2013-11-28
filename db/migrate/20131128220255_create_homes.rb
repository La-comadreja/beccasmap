class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.text :html
      t.boolean :lastview_changed_at
      t.datetime :lastview

      t.timestamps
    end
  end
end
