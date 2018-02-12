require 'nokogiri'
require 'open-uri'

class MyAnimeList::Anime

  @@hashes = []
  @@objects = []
  @@url = "https://myanimelist.net/topanime.php"

  attr_accessor :name, :show_length, :time_aired, :members_watched, :ranking, :url, :description

  # https://myanimelist.net/topanime.php
  # https://myanimelist.net/anime/5114/Fullmetal_Alchemist__Brotherhood

  def self.scrape_index_page
    html = open(@@url)
    doc = Nokogiri::HTML(html)
    #    doc.css("div.information.di-ib.mt4").each do |example|
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

  def self.scrape_anime_page_profile(url)
    #want genres, description
    #for genres, prob need to determine based off of title and iterate through that list
    #for description, need to understand how to interact with a class.
    html = open(url)
    doc = Nokogiri::HTML(html)
    # name = doc.css("div.pb16 description").text
    name = doc.at("//span[@itemprop = 'description']").children.text
    parsed_info = name.split(/\n|\"|\r/)
    summary = ""
    parsed_info.each do |description|
      if description != "" && description != "[Written by MAL Rewrite]"
        if description.include? "\u2014"
          array = description.split(/\u2014/)
          word = ""
          array.each do |no_dashes|
            if word == ""
              word = word + " " + no_dashes
            else
              word = word + " - " + no_dashes
            end
          end
          if summary == ""
            summary = summary + word.lstrip.rstrip
          else
            summary = summary + " " + word.lstrip.rstrip
          end
        elsif summary == ""
          summary = summary + description.lstrip.rstrip
        else
          summary = summary + " " + description.lstrip.rstrip
        end
        # binding.pry
      end
    end
    summary
    #name = doc.css("span")[10]
    #doc.css("div.js-scrollfix-bottom div
  end

  def self.today
    self.scrape_index_page
    @@hashes.each do |anime_show_or_movie|
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
      if anime.url.include? "Â°"
        replace = anime.url.split("Â")
        complete_item = replace[0] + replace[1]
        anime.url = complete_item
      end
      @@objects << anime
    end
    # @@objects.each do |anime_show_or_movie|
    #   self.scrape_anime_page_profile(anime_show_or_movie.url)
    # end
    @@objects

    # puts <<-DOC
    #   1. Shaman King
    #   2. Pokemon
    # DOC
  end

end