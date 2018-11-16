require './config/environment'

class BooksController < ApplicationController

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/books' do
    erb :'books/books'
  end
end
