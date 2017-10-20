[Bookmark, Song].each do |c|
  c.destroy_all
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

hey_joe = Song.create!(
  title: "Hey Joe",
  note: "Play in standard tuning\n\nAnd some other note here",
  youtube_url: "https://www.youtube.com/watch?v=9hD44jOQG4Q",
)

Bookmark.create!(
  name: "Start of lesson",
  seconds: 65,
  song: hey_joe,
)

Bookmark.create!(
  name: "Some other section",
  seconds: 276,
  song: hey_joe,
)

Bookmark.create!(
  name: "The best section!",
  seconds: 410,
  song: hey_joe,
)

Song.create!(
  title: "Comfortably Numb",
  youtube_url: "https://www.youtube.com/watch?v=NCP-y7IE9zI",
)

november_rain = Song.create!(
  title: "November Rain",
  youtube_url: "https://www.youtube.com/watch?v=xiz928F3GhM",
)

FactoryGirl.create_list(:bookmark, 15, song: november_rain)
