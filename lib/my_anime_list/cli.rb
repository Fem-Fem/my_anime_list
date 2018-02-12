class MyAnimeList::CLI


  def call
    list_anime
    menu
    goodbye
  end

  def list_anime
    puts "Best anime:"
    @anime = MyAnimeList::Anime.today
    @anime.each.with_index(1) do |show, i|
      puts "#{i}. #{show.name}; Show Popularity: #{show.members_watched}; Show Length: #{show.time_aired}; Show Length: #{show.show_length}"
      puts show.url
    end
  end

  def menu
    puts "Enter the number of the anime that you would like to learn more about!"
    input = gets.strip.downcase
    if input.to_i > 0
      puts @anime[input.to_i - 1]
      puts @anime[input.to_i - 1].url
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