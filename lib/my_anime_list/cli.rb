class MyAnimeList::CLI

  @@url = "https://myanimelist.net/topanime.php"

  def call
    list_anime
    menu
    goodbye
  end

  def list_anime
    puts "Best anime:"
    @anime = MyAnimeList::Anime.today
    @anime.each.with_index(1) do |show, i|
      puts "#{i}. #{show.name}; Show Popularity: #{show.popularity}; Show Rating: #{show.rating}"
    end
  end

  def menu
    puts "Enter the number of the anime that you would like to learn more about!"
    input = gets.strip.downcase
    if input.to_i > 0
      puts @anime[input.to_i - 1]
      puts @anime[input.to_i - 1].description
    elsif input == "list"
      list_anime
      menu
    else
      puts "Not sure what you want! Please type list or exit!"
    end
  end

  def goodbye
    puts "See you next time!"
  end

end
