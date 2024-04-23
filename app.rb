require "sinatra"
require "sinatra/reloader"
require "sinatra/cross_origin"
require "sinatra/json"
require "open-uri"
require "date"
# require "nokogiri"
require 'watir'
require "pry"
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
  url = "https://github.com/#{params[:user_name]}"

  browser = Watir::Browser.new :chrome, options: { args: %w[--headless --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222]}
  browser.goto(url)
  Watir::Wait.until { browser.td(data_date: formatted_today).present? }

  contrib_id = browser.td(data_date: formatted_today).id
  commit_nb = browser.element(for: contrib_id).text.split[0].to_i
  location_element = browser.element(class: 'p-label').text.split(', ')
  contrib = {
    day: formatted_today,
    user_name: params[:user_name],
    commits: commit_nb,
    location: location_element,
  }
  browser.close
  json contrib
end

options '*' do
  response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
  response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
  response.headers['Access-Control-Allow-Origin'] = '*'
  200
end

# # DO NOT CHANGE BELOW LINES
# # Some configuration for Sinatra to be hosted and operational on Heroku
# after do
#   # Close the connection after the request is done so that we don't
#   # deplete the ActiveRecord connection pool.
#   ActiveRecord::Base.connection.close
# end
