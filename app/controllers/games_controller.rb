require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @score = score_and_message(@word, @letters)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def score_and_message(word, letters)
    if included?(word.upcase, letters)
      if english_word?(word)
        "Congratulations! #{word} is a valid English word"
      else
        "Sorry but #{word} does not seem a valid English word"
      end
    else
      "Sorry but #{word} can't be build out of #{letters}"
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
