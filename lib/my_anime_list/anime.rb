require 'open-uri'

class MyAnimeList::Anime

  @@all = []
  @@url = "https://myanimelist.net/topanime.php"

  attr_accessor :name, :popularity, :rating, :description

  # https://myanimelist.net/topanime.php


  def self.scrape_index_page
    html = open(@@url)
    doc = Nokogiri::HTML(html)
    hello = doc.css("div.ranking-list")
    doc.css("div.information.di-ib.mt4").each do |example|
      hash = {}
      info = example.text.strip
      parsed_info = info.split(/\n/)
      hash[show_length] = parsed_info[0]
      hash[time_aired] = parsed_info[1]
      hash[members_watched] = parsed_info[2]
      binding.pry
      hash.rank = example.text
      @@all << hash
    end

  end
  #
  # def self.scrape_profile
  #
  # end

  def self.today
    self.scrape_index_page
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
