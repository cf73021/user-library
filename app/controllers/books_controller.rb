require './config/environment'

class BooksController < ApplicationController

  configure do
    enable :sessions
    set :session_secret, "secret"
  end
  
end
