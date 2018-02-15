class MyAnimeList::CLI

  @@all = []
  @@anime = []
  @@hashes = []

  def call
    make_anime
    add_extensive_details_to_anime
    list_anime
    menu
    goodbye
  end

  def make_anime
    puts "Loading..."
    @@hashes = MyAnimeList::Scraper.scrape_index_page
    @@anime = MyAnimeList::Anime.today(@@hashes)
  end

  def add_extensive_details_to_anime
    @@anime.each do |anime_show_or_movie|
      MyAnimeList::Scraper.scrape_anime_page_profile(anime_show_or_movie.url, anime_show_or_movie)
    end
    @@anime
  end

  def list_anime
    puts "Best anime:"
    @@anime.each.with_index(1) do |show, i|
      @@all << show
      puts "#{i}. #{show.name}; Show Popularity: #{show.members_watched}; Show Length: #{show.time_aired}; Show Length: #{show.show_length}"
      puts "--------------------------------------------------------------------------------------------------------------------------------------------"
    end
  end

  def re_list_anime
    puts "If you would like to see the top x anime, please enter an integer less than 50. If you would like to see all of the anime again, please enter '50'"
    limit = gets.strip.to_i
    @@all.each.with_index(1) do |show, i|
      if i <= limit
        puts "#{i}. #{show.name}; Show Popularity: #{show.members_watched}; Show Length: #{show.time_aired}; Show Length: #{show.show_length}"
      end
    end
    menu
  end

  def menu
    puts "Enter the number of the anime that you would like to learn more about!"
    puts "You can also enter 'list' to see the list again, or 'exit' to exit."
    input = gets.strip.downcase
    if input.to_i > 0
      puts "Name: #{@@anime[input.to_i - 1].name}"
      puts "Genres: #{@@anime[input.to_i - 1].genres}"
      puts "\n"
      puts "Description: #{@@anime[input.to_i - 1].description}"
      puts "\n"
      open_in_broswer(@@anime[input.to_i - 1].url)
      menu
    elsif input == "list"
      re_list_anime
    elsif input == "exit"
      # exit program
    else
      puts "Command not found"
      menu
    end
  end

  def open_in_broswer(url)
    puts "If you would like to have the url of this page, please enter 'Y'. Else, enter anything else."
    input = gets.strip.upcase
    if input == "Y"
      # need to find way to open link
      puts url
    end
  end

  def goodbye
    puts "See you next time!"
  end

end
