require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @alphabet = ("A".."Z").to_a
    @letters = []
    10.times do
      @letters << @alphabet.sample
    end
  end

  def score
    @word = params[:your_word].upcase.split("")
    @letters = params[:letters].split(" ")
    @wordexists = word_exists?(@word, @letters)
    if @wordexists == true
      @message = fetchword(@word)
    else
      @message = "Sorry but #{@word} can't be build of #{@letters}"
    end
  end

  def fetchword(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word.join}"
    user_serialized = open(url).read
    data = JSON.parse(user_serialized)
    if data["found"] == true
      return "Congratulations! #{word.join} seems to be an english word!"
    elsif data["found"] == false
      return "Sorry but #{word.join} doesn't seem to be a valid english word"
    end
  end

  def word_exists?(word,letters)
    word.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end
end
