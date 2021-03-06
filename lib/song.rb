require 'pry'
class Song
  attr_accessor :name, :artist, :genre

  @@all = []

  def initialize(name, artist = nil, genre = nil)
    @name = name
    if artist
      self.artist = artist # self.artist assigns instance's artist property to that artist
    end
    if genre
      self.genre = genre
    end
  end


  def self.all
    @@all
  end

  def self.destroy_all
    @@all.clear
  end

  def save
    @@all << self
  end

  def self.create(name)
    song = self.new(name)
    song.save
    song
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    genre.add_song(self)
  end

  def self.find_by_name(name)
    self.all.detect {|song| song.name == name}
  end

  def self.find_or_create_by_name(name) # how does it know which to do?
    # self.find_by_name(name) || self.find_or_create_by_name(name)
    result = @@all.detect do |song|
      song.name == name
    end
    result || self.find_by_name(name) || self.create(name)
  end

  def self.new_from_filename(file_name)
  #   binding.pry
    # artist_name, song_name, genre = file_name.split(" - ")
    array = file_name.split(" - ")
    song = self.new(array[1])
    song.artist = Artist.find_or_create_by_name(array[0])
    song.genre = Genre.find_or_create_by_name(array[2].gsub(".mp3", ""))
    song
  end

  def self.create_from_filename(file_name)
    song = self.new_from_filename(file_name)
    song.save
  end
end
