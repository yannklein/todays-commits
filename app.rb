require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require "sinatra/json"
require 'open-uri'
require 'date'
require 'nokogiri'
# Commented out as the project don't use DB
# require 'sinatra/activerecord'
# require_relative 'config/application'

configure do
  enable :cross_origin
end

get '/' do
  erb :index
end

get '/:user_name' do
  cross_origin :allow_origin, :any
  url = "https://github.com/#{params[:user_name]}"
  raw_html = URI.open(url).read
  html_doc = Nokogiri::HTML(raw_html)
  contrib_element = html_doc.search("rect[data-date='#{ Date.today.strftime('%Y-%m-%d')}']")
  location_element = html_doc.search(".p-label").text.split(", ")
  contrib = {
    day: Date.today.strftime('%Y-%m-%d'),
    user_name: params[:user_name],
    commits: contrib_element.attribute("data-count").value,
    location: location_element
  }
  json contrib
end



# # DO NOT CHANGE BELOW LINES
# # Some configuration for Sinatra to be hosted and operational on Heroku
# after do
#   # Close the connection after the request is done so that we don't
#   # deplete the ActiveRecord connection pool.
#   ActiveRecord::Base.connection.close
# end