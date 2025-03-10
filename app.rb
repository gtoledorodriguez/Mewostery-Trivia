require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "dotenv/load"

get("/") do
  @cataas_url = "https://cataas.com/cat"

  trivia_url = "https://opentdb.com/api_category.php"
  raw_trivia_data = HTTP.get(trivia_url)
  @parsed_trivia_data = JSON.parse(raw_trivia_data)
  @category = @parsed_trivia_data.fetch("trivia_categories")
  @category.insert(0, {"id"=>0, "name"=>"Any Category"})

  @difficulty = ["Any Difficulty", "Easy", "Medium", "Hard"]

  
  erb(:homepage)
end

get("/trivia") do
  @cataas_url = "https://cataas.com/cat"
  trivia_url = "https://opentdb.com/api.php?amount=1&type=multiple"
  @category = params.fetch("category")
  if @category != 0
    trivia_url = trivia_url + "&category=#{}"
  end
  @difficulty = params.fetch("difficulty")
  if @difficulty != "Any Difficulty"
    trivia_url = trivia_url + "&difficulty=#{@difficulty.downcase}"
  end
  
  raw_trivia_data = HTTP.get(trivia_url)
  @parsed_trivia_data = JSON.parse(raw_trivia_data)
  results = @parsed_trivia_data.fetch("results").at(0)
  @question = results.fetch("question")
  @correct_answer = results.fetch("correct_answer")
  @answers = results.fetch("incorrect_answers")
  @answers.push(@correct_answer)
  @answers = @answers.shuffle

  erb(:trivia)
end

get("/solve") do
  @cataas_url = "https://cataas.com/cat"
  @answer = params.fetch("answer")
  @correct_answer = params.fetch("correct_answer")
  @reply = ""
  if @answer == @correct_answer
    @reply = "Purr-fect! You nailed it! 😸🎉"
    @cataas_url = @cataas_url + "/happy"
  else @answer == @correct_answer
      @reply = "Oh no, that's a cat-astrophe! 😿 The correct answer is... #{@correct_answer}"
      @cataas_url = @cataas_url + "/grumpy"
  end

  erb(:solve)
end
