class MyAnimeList::Scraper

  @@url = "https://myanimelist.net/topanime.php"

  def self.get_page
    doc = Nokogiri::HTML(open(@@url))
  end

  def self.scrape_index_page
    self.get_page.css("tr.ranking-list")
  end

  def self.make_anime
    scrape_index_page.each do |a|
      new_from_index_page(a)
    end
  end

  def self.new_from_index_page(a)

    anime_info = a.css("div.detail div.information.di-ib.mt4").text.strip
    parsed_anime_info = anime_info.split(/\n/)

    MyAnimeList::Anime.new(
      a.css("div.detail div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b").text,
      parsed_anime_info[0],
      parsed_anime_info[1].strip,
      parsed_anime_info[2].strip,
      a.css("div.detail div.di-ib.clearfix a.hoverinfo_trigger.fl-l.fs14.fw-b")[0].attributes["href"].value
    )
  end

  def self.doc(url)
    @doc ||= Nokogiri::HTML(open(url))
  end

  def self.add_extensive_details_to_anime(anime)
    genres_finder(anime)
    description_finder(anime)
    #grab anime url
    #scrape page for genre and description possibly with helper methods
  end

  def self.genres_finder(anime)
    genres = ""
    genres_rough_info = doc(anime.url).css('div')[1].children.children.children.to_s.split(/genres|.setCollapse/)
    genres_rough_info.each do |example|
      if example[0..4] == "\", [\""
        genres = example
      end
    end
    anime.genres = genres[4..200].gsub(/\",\"/, ", ")[1..-4]
  end

  def self.description_finder(anime)
    name = doc(anime.url).at("//span[@itemprop = 'description']").children.text.split(/\n|\"|\r/)
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
    anime.description = final_description
  end

end
