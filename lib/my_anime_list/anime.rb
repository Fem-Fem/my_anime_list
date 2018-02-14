require 'nokogiri'
require 'open-uri'
require 'pry'

class MyAnimeList::Anime

  ## don't need the hashes, shouldn't need the url either
  @@objects = []
  @@url = "https://myanimelist.net/topanime.php"

  attr_accessor :name, :show_length, :time_aired, :members_watched, :ranking, :url, :description, :rating, :genres

  def self.today(hashes)
    ## remake CLI, delete lien below, make it input hashes
    #self.scrape_index_page
    hashes.each do |anime_show_or_movie|
      anime = self.new
      anime.name = anime_show_or_movie[:name]
      if anime.name.include? "Â°"
        replace = anime.name.split("Â")
        complete_item = replace[0] + replace[1]
        anime.name = complete_item
      end

      anime.show_length = anime_show_or_movie[:show_length]
      anime.time_aired = anime_show_or_movie[:time_aired]
      anime.members_watched = anime_show_or_movie[:members_watched]
      anime.url = anime_show_or_movie[:url]

      #for Gintama weird name
      if anime.url.include? "Â°"
        replace = anime.url.split("Â°")
        complete_item = replace[0]
        anime.url = complete_item
      end

      @@objects << anime
    end
    @@objects.each do |anime_show_or_movie|
      #self.scrape_anime_page_profile(anime_show_or_movie.url, anime_show_or_movie)
    end
    @@objects

  end

end
