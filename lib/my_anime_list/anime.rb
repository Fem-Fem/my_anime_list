require 'nokogiri'
require 'open-uri'
require 'pry'

class MyAnimeList::Anime

  @@all = []
  @@counter = 0

  attr_accessor :name, :show_length, :time_aired, :members_watched, :url, :description, :genres

  def self.new_from_index_page(a)

    anime_info = a.css("div.detail div.information.di-ib.mt4").text.strip
    parsed_anime_info = anime_info.split(/\n/)

    self.new(
      a.css("div.detail div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b").text,
      parsed_anime_info[0],
      parsed_anime_info[1].strip,
      parsed_anime_info[2].strip,
      a.css("div.detail div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b")[0].attributes["href"].value
    )
  end

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

  def doc
    @doc ||= Nokogiri::HTML(open(self.url))
  end

  def self.find(int)
    @@all[int-1]
  end

  def genres
      genres = ""
      genres_rough_info = doc.css('div')[1].children.children.children.to_s.split(/genres|.setCollapse/)
      genres_rough_info.each do |example|
        if example[0..4] == "\", [\""
          genres = example
        end
      end
      @genres = genres[4..200].gsub(/\",\"/, ", ")[1..-4]
  end

  def description
      name = doc.at("//span[@itemprop = 'description']").children.text.split(/\n|\"|\r/)
      final_description = ""
      name.each do |description|
        if description != "" && description != "[Written by MAL Rewrite]"
          if description.include? "\u2014"
            array = description.split(/\u2014/)
            word = ""
            array.each do |phrase|
              if word == ""
                word = word + " " + phrase
              else
                word = word + " - " + phrase
              end
            end
            if final_description == ""
              final_description = final_description + word.strip
            else
              final_description = final_description + " " + word.strip
            end
          elsif final_description == ""
            final_description = final_description + description.strip
          else
            final_description = final_description + " " + description.strip
          end
        end
      end
      @summary = final_description
  end
end
