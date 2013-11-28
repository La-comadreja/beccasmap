class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.text :html
      t.boolean :update

      t.timestamps
    end
  end
end
