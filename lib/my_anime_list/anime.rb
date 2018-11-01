class MyAnimeList::Anime

  @@all = []

  attr_accessor :name, :show_length, :time_aired, :members_watched, :url, :description, :genres

  def initialize(name=nil, show_length=nil, time_aired=nil, members_watched=nil, url=nil)
    @name = name
    @show_length = show_length
    @time_aired = time_aired
    @members_watched = members_watched
    @url = url
    if_gintama?
    @@all << self
  end

  def if_gintama?
    if self.name.include? "Â°"
      replace = self.name.split("Â")
      complete_item = replace[0] + replace[1]
      self.name = complete_item
      replace = self.url.split("Â°")
      complete_item = replace[0]
      self.url = complete_item
    end
  end

  def self.all
    @@all
  end

  def self.find(int)
    @@all[int-1]
  end

end
