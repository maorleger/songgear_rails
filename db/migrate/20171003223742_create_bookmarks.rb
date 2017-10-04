class CreateBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :bookmarks do |t|
      t.references :song, foreign_key: true
      t.integer :seconds
      t.string :title

      t.timestamps
    end
  end
end
