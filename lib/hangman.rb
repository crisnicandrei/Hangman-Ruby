require 'yaml'
class Hangman
    def initialize
        puts "--------Welcome to Hangman!-----------"
        main_menu
    end

    def main_menu
        puts "New Game!"
        puts "Load previous data"
        puts "Quit"
        menu_selection
    end


    def menu_selection
        user_input=gets.chomp.downcase
        if user_input=="n"
            new_game
        elsif
            user_input=="l"
            load_game
        elsif
            user_input=="q"
            quit_game
        else
            main_menu
        end
    end

    def quit_game
        puts "Thanks for playing!"
        exit
    end


    def new_game
        @word=chosen_word
        @wrong=[]
        @dashes=split_word
        @remaining_attempts=11
        play_round
    end

    def play_round
        puts "If you wish to save, type save in the console!"
        puts "If you wish to go back to the menu, type menu!"
        puts "If you wish to exit,type exit"
        while @remaining_attempts>0
            puts ""
            puts @dashes.join("")
            puts ""
            puts @wrong.join(",")
            puts ""
            puts "Chances remaining: #{@remaining_attempts}"
            puts ""
            puts "Please choose a letter!"
            enter_letter
        end
        game_over
    end


    def enter_letter
        attempt=gets.chomp.downcase
        if attempt == "save"
            save_game
        elsif attempt=="menu"
            main_menu
        elsif attempt=="exit"
            quit_game
        else
            check_guess(attempt)
        end
    end

    def check_guess attempt
        if @wrong.include? attempt
            puts "You already tried that letter!"
            play_round
        elsif @dashes.include? attempt
            puts "You already tried that!"
        else
            check_word attempt
        end
    end
    
    def check_word attempt
        @word.split("").each_with_index do |character,index|
            if character==attempt
                @dashes[index]=character
            end
        end
        true_or_false attempt
    end

    def true_or_false attempt
        if @word.include? attempt
            puts "Yes!"
            puts ""
            if @dashes.join("")==@word
                puts "You win! Bravo! The word is #{@word}."
                puts ""
                main_menu
            end
        else
            puts "No!"
            puts
            @wrong<<attempt
            @remaining_attempts-=1
        end
    end


    

    def game_over
        puts "You ran out of lives! Bad luck!The word was #{@word} Try again?"
        main_menu
    end
            






    def dictionary
        File.open("5desk.txt","r").readlines.select do |line|
       line.length>4 && line.length<13 && line[0].match(/\p{lower}/)
        end
    end



    def chosen_word
        dictionary.sample.chomp
   end


    def split_word 
        @word.split("").map do |letter|
            letter="*"
        end
    end

    def save_game
        Dir.mkdir("saves") unless Dir.exists?("saves")
        File.open("saves/saved.yaml","w") do |file|
        file.write(YAML::dump(self))
        end
        puts "Game saved!"
        main_menu
    end

    def load_game
        if File.exists?("saves/saved.yaml")
        saved_game=YAML::load(File.read("saves/saved.yaml"))
        saved_game.play_round
        else
        puts "No saves found!"
        main_menu
    
        end

    end
end


game=Hangman.new
