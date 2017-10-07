class AddNoteToSong < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :note, :text
  end
end
