require 'nokogiri'
require 'open-uri'
require 'pry'

class MyAnimeList::Scraper

  @@hashes = []
  @@objects = []
  @@url = "https://myanimelist.net/topanime.php"
  # https://myanimelist.net/topanime.php
  # https://myanimelist.net/anime/5114/Fullmetal_Alchemist__Brotherhood

  def self.scrape_index_page
    html = open(@@url, 'User-Agent' => 'Test2')
    doc = Nokogiri::HTML(html)
    doc.css("tr.ranking-list").each do |example|
      hash = {}
      name = example.css("div.detail div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b")
      hash[:name] = example.css("div.detail div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b").text
      hash[:url] = name[0].attributes["href"].value
      anime_info = example.css("div.detail div.information.di-ib.mt4").text.strip
      parsed_info = anime_info.split(/\n/)
      hash[:show_length] = parsed_info[0]
      hash[:time_aired] = parsed_info[1].strip
      hash[:members_watched] = parsed_info[2].strip
      hash[:rating] = example.css("div.js-top-ranking-score-col.di-ib.al").text
      @@hashes << hash
    end
    return @@hashes
  end

  def self.scrape_anime_page_profile(url, anime_show_or_movie)
    html = open(url,'User-Agent' => 'Test2')
    doc = Nokogiri::HTML(html)

    # genres = doc.css("div")[45].text
    # text = ""
    # genre = genres.split(/\n| Genres:/)
    # genre.each do |type|
    #   if type != "" && type != " "
    #     text = text + type.lstrip
    #   end
    # end

    # robust genre
    gen = ""
    hello = doc.css('div')[1].children.children.children.to_s
    hi = hello.split(/\genres|.setCollapse/)
    hi.each do |example|
      if example[0..4] == "\", [\""
        gen = example
      end
    end
    gen = gen[4..200]
    gen = gen.gsub(/\",\"/, ", ")
    gen = gen[1..200]
    gen = gen[0..-4]
    genres = gen

    #description info
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
      end
    end

    # anime_show_or_movie.genres = text
    anime_show_or_movie.genres = genres
    anime_show_or_movie.description = summary
    return [genres, summary]
  end

  def self.today
    @@objects.each do |anime_show_or_movie|
      self.scrape_anime_page_profile(anime_show_or_movie.url, anime_show_or_movie)
    end
    @@objects

  end

end