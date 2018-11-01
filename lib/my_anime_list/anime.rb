require 'nokogiri'
require 'open-uri'
require 'pry'

class MyAnimeList::Anime

  @@all = []

  attr_accessor :name, :show_length, :time_aired, :members_watched, :ranking, :url, :description, :genres

  def self.new_from_index_page(a)

    anime_info = a.css("div.detail div.information.di-ib.mt4").text.strip
    parsed_anime_info = anime_info.split(/\n/)
    self.new(
      a.css("div.detail div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b").text,
      parsed_info[0],
      parsed_info[1].strip,
      parsed_info[2].strip,
      a.css("div.detail div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b")[0].attributes["href"].value
    )
  end

  def initialize(name=nil, show_length=nil, time_aired=nil, members_watched=nil, url=nil)
    @name = name
    @show_length = url
    @time_aired = location
    @members_watched = position
    @url = url
    @@all << self
  end

  def doc
    @doc ||= Nokogiri::HTML(open(self.url))
  end

  def genres
      genre = ""
      rough_info = doc.css('div')[1].children.children.children.to_s
      genre_rough_info = rough_info.split(/genres|.setCollapse/)
      genre_rough_info.each do |example|
        if example[0..4] == "\", [\""
          genre = example
        end
      end
      # make method?
      genre = genre[4..200]
      genre = genre.gsub(/\",\"/, ", ")
      genre = genre[1..200]
      genre = genre[0..-4]
      genres = genre
  end

  def description
  end

  # def self.today(anime_detailed_info)
  #   anime_detailed_info.each do |anime_show_or_movie|
  #     anime = self.new
  #     anime.name = anime_show_or_movie[:name]
  #     if anime.name.include? "Â°"
  #       replace = anime.name.split("Â")
  #       complete_item = replace[0] + replace[1]
  #       anime.name = complete_item
  #     end
  #
  #     anime.show_length = anime_show_or_movie[:show_length]
  #     anime.time_aired = anime_show_or_movie[:time_aired]
  #     anime.members_watched = anime_show_or_movie[:members_watched]
  #     anime.url = anime_show_or_movie[:url]
  #
  #     #for Gintama weird case
  #     if anime.url.include? "Â°"
  #       replace = anime.url.split("Â°")
  #       complete_item = replace[0]
  #       anime.url = complete_item
  #     end
  #
  #     @@all << anime
  #   end
  #   @@all
  # end

end
