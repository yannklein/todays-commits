require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require "sinatra/json"
require 'open-uri'
require 'date'
require 'nokogiri'
require 'pry'
# Commented out as the project don't use DB
# require 'sinatra/activerecord'
# require_relative 'config/application'

configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

get '/' do
  erb :index
end

get '/:user_name' do
  formatted_today = Date.today.strftime('%Y-%m-%d')
  url = "https://github.com/#{params[:user_name]}?from=#{formatted_today}&to=#{formatted_today}"
  raw_html = URI.open(url).read
  html_doc = Nokogiri::HTML.parse(raw_html)
  contrib_item = html_doc.search(".TimelineItem-body span")[0]
  location_element = html_doc.search(".p-label").text.split(", ")
  contrib = {
    day: formatted_today,
    user_name: params[:user_name],
    commits: contrib_item.text.strip.split(' ')[1].to_i,
    location: location_element
  }
  json contrib
end

options "*" do
  response.headers["Allow"] = "GET, PUT, POST, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end


# # DO NOT CHANGE BELOW LINES
# # Some configuration for Sinatra to be hosted and operational on Heroku
# after do
#   # Close the connection after the request is done so that we don't
#   # deplete the ActiveRecord connection pool.
#   ActiveRecord::Base.connection.close
# end