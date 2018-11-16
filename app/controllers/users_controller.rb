require './config/environment'

class UsersController < ApplicationController

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/signup' do
    if User.logged_in?(session)
      redirect to '/tweets'
    else
      erb :'users/create_user'
    end
  end

  get '/login' do
    if User.logged_in?(session)
      redirect to '/tweets'
    else
      erb :'users/login'
    end
  end

  get '/logout' do
    if User.logged_in?(session)
      session.clear
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  post '/signup' do
    @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])

    if @user.save
      session[:user_id] = @user.id
      redirect to "/tweets"
    else
      @error_message = "You must enter a username, email and password!"
      @users = User.all
      redirect to "/signup"
    end
  end

  post '/sessions' do
    @user = User.find_by(username: params["username"], email: params["email"], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect to "/tweets"
    else
      redirect to "/signup"
    end
  end

  post '/login' do
    @user = User.find_by(username: params["username"])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/tweets'
    else
      redirect to "/login"
    end
  end

end
