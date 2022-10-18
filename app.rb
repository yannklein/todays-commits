require 'sinatra'
require 'sinatra/reloader'
# Commented out as the project don't use DB
# require 'sinatra/activerecord'
# require_relative 'config/application'

get '/' do
  @hello = 'Hi there!'
  erb :index
end



# DO NOT CHANGE BELOW LINES
# Some configuration for Sinatra to be hosted and operational on Heroku
after do
  # Close the connection after the request is done so that we don't
  # deplete the ActiveRecord connection pool.
  ActiveRecord::Base.connection.close
end