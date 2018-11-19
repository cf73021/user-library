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

  get '/books/new' do
    if User.logged_in?(session)
      erb :'books/new'
    else
      redirect to "/login"
    end
  end

  get '/books/:id' do
    if User.logged_in?(session)
      @book = Book.find(params[:id])
      erb :'books/show_book'
    else
      redirect to "/login"
    end
  end

  get '/books/:id/edit' do
    if User.logged_in?(session)
      @book = Book.find(params[:id])
      erb :'books/edit_book'
    else
      redirect to "/login"
    end
  end

  post '/books' do
    if User.logged_in?(session)
      user = User.current_user(session)
      book = Book.new(title: params[:title], author: params[:author])
      book.user = user
      book.save
      redirect to "/books"
    else
      redirect to "/login"
    end
  end

  patch '/books/:id/edit' do
    if User.logged_in?(session)
      user = User.current_user(session)
      book = Book.find_by(id: params[:id])
      if book && user.id == book.user.id
        book.title = params[:title]
        book.author = params[:author]
        if !book.save
          redirect to "/books/#{book.id}/edit"
        end
      end
    end
    redirect to '/books'
  end

  delete '/books/:id/delete' do
    if User.logged_in?(session)
      user = User.current_user(session)
      book = Book.find_by(id: params[:id])
      if book && user.id == book.user.id
        book.destroy
      end
    end
    redirect to '/books'
  end

end
