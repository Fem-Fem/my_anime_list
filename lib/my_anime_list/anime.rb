require 'open-uri'

class MyAnimeList::Anime

  @@all = []

  attr_accessor :name, :popularity, :rating, :description

  # https://myanimelist.net/topanime.php


  def self.scrape_index_page(url)
    html = open(url)
    doc = Nokogiri::HTML(html)
    doc.css("div.ranking-list").each do |example|
      hash = {}
      hash.rank = example.css("div.text-on")
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
