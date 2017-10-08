class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :title
      t.text :note
      t.string :video_id

      t.timestamps
    end
  end
end
