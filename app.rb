require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "dotenv/load"

get("/") do
  @cataas_url = "https://cataas.com/cat"
  
  erb(:homepage)
end

get("/trivia") do
  @cataas_url = "https://cataas.com/cat"
  
  erb(:homepage)
end
