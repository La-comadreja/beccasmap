class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :category
      t.datetime :datetime
      t.string :name
      t.string :venue
      t.string :address
      t.decimal :latitude
      t.decimal :longitude
      t.string :link
      t.decimal :price
      t.text :description
    end
  end
end
