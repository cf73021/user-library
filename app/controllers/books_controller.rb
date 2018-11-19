require './config/environment'

class BooksController < ApplicationController

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/books' do
    @books = Book.all
    if User.logged_in?(session)
      erb :'books/books'
    else
      redirect to "/login"
    end
  end
end
