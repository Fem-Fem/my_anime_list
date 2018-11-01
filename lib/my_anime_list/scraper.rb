require 'pry'

class MyAnimeList::Scraper

  @@hashes = []
  @@objects = []
  @@url = "https://myanimelist.net/topanime.php"

  def self.get_page
    doc = Nokogiri::HTML(open(@@url))
  end

  def self.scrape_index_page
    self.get_page.css("tr.ranking-list")
  end

  def self.make_anime
    scrape_index_page.each do |a|
      MyAnimeList::Anime.new_from_index_page(a)
    end
  end

end
