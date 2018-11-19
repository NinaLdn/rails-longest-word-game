class GamesController < ApplicationController

  def new
    # display a new random grid and a form
    @alphabet = ("A".."Z").to_a
    @letters = []
    10.times do |letter|
      @letters << @alphabet.sample
    end
  end

  def score
    # The form will be submitted (with POST)
    @word = params[:word]
    @letters = params[:letters_array]
    if included?(@word, @letters)
      if english_word?(attempt)
        score = compute_score(attempt, time)
        [score, "Congratulations! ${@word} is a valid English word"]
      else
        [0, "Sorry, but ${@word} does not seem to be a valid English word..."]
      end
    else
      [0, "Sorry, but ${@word} can't be build ouf of ${@letters}"]
    end
  end

end

private

def compute_score(word)
  word.length * 10
end

def included?(word, letters)
  word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
end

def english_word?(word)
  response = open("https://wagon-dictionary.herokuapp.com/#{word}")
  json = JSON.parse(response.read)
  return json['found']
end

def score_and_message(attempt, grid, time)
  if included?(attempt.upcase, grid)
    if english_word?(attempt)
      score = compute_score(attempt, time)
      [score, "well done"]
    else
      [0, "not an english word"]
    end
  else
    [0, "not in the grid"]
  end
end
