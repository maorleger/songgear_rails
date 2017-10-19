class CreateBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :bookmarks do |t|
      t.string :name
      t.integer :seconds
      t.references :song, foreign_key: true

      t.timestamps
    end
  end
end
