require 'open-uri'

class MyAnimeList::Anime

  @@hashes = []
  @@objects = []
  @@url = "https://myanimelist.net/topanime.php"

  attr_accessor :name, :show_length, :time_aired, :members_watched, :ranking, :url

  # https://myanimelist.net/topanime.php


  def self.scrape_index_page
    html = open(@@url)
    doc = Nokogiri::HTML(html)
    #    hello = doc.css("div.ranking-list")
    #    doc.css("div.information.di-ib.mt4").each do |example|
    #        doc.css("div.detail").each do |example|
    hello = doc.css("div.ranking-list")
    doc.css("div.detail").each do |example|
      hash = {}
      name = example.css("div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b")
      hash[:name] = example.css("div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b").text
      hash[:url] = name[0].attributes["href"].value
      anime_info = example.css("div.information.di-ib.mt4").text.strip
      parsed_info = anime_info.split(/\n/)
      hash[:show_length] = parsed_info[0]
      hash[:time_aired] = parsed_info[1].strip
      hash[:members_watched] = parsed_info[2].strip
      # hash.rank = example.text
      @@hashes << hash
    end
    # doc.css("div.js-top-ranking-score-col.di-ib.al").each.with_index do |rating, anime|
    #   @@hashes[anime][:rating] = rating.text
    # end

  end

  # def self.scrape_profile
  #
  # end

  def self.today
    self.scrape_index_page
    @@hashes.each do |anime_show_or_movie|
      anime = self.new
      anime.name = anime_show_or_movie[:name]
      anime.show_length = anime_show_or_movie[:show_length]
      anime.time_aired = anime_show_or_movie[:time_aired]
      anime.members_watched = anime_show_or_movie[:members_watched]
      anime.url = anime_show_or_movie[:url]
      @@objects << anime
    end
    @@objects

    # puts <<-DOC
    #   1. Shaman King
    #   2. Pokemon
    # DOC
    #
    # anime_1 = self.new
    # anime_1.name = "Shaman King"
    # anime_1.popularity = "4"
    # anime_1.rating = "7"
    # anime_1.description = "Really cool anime about spirits!"
    # anime_2 = self.new
    # anime_2.name = "Pokemon"
    # anime_2.popularity = "13"
    # anime_2.rating = "8"
    # anime_2.description = "Really interesting anime about pets!"
    # array = [anime_1, anime_2]
  end

end
