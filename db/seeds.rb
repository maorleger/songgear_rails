[Song].each do |c|
  c.destroy_all
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

Song.create!(
  title: "Hey Joe",
  note: "Play in standard tuning\n\nAnd some other note here",
  youtube_url: "https://www.youtube.com/watch?v=9hD44jOQG4Q",
)
