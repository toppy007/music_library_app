# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/' do
    return erb(:index)
  end

  get '/hello' do
    @name = 'Chris'

    return erb(:hello)
  end
  
  get '/albums/new' do
    return erb(:new_album)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    artist_name = ArtistRepository.new

    @album = repo.find(params[:id])
    @artist_name = artist_name.find(@album.artist_id)

    return erb(:albums)
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all 
    return erb(:all_albums)
  end

  post '/albums' do
    if invalid_request_parameters?
      # Set the response code
      # to 400 (Bad Request) - indicating
      # to the client it sent incorrect data
      # in the request.
      status 400
  
      return ''
    end
    # Get request body parameters
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]

    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    return erb(:added_album)
  end

  def invalid_request_parameters?
    # Are the params nil?
    return true if  params[:title] == nil || 
                    params[:release_year] == nil || 
                    params[:artist_id] == nil
  
    # Are they empty strings?
    return true if  params[:title] == "" || 
                    params[:release_year] == "" || 
                    params[:artist_id] == ""
    return false
  end

  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])

    return erb(:artists)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artist = repo.all 
    return erb(:all_artists)
  end

  post '/artists' do
    if invalid_request?
      # Set the response code
      # to 400 (Bad Request) - indicating
      # to the client it sent incorrect data
      # in the request.
      status 400
  
      return ''
    end
    # Get request body parameters
    name = params[:name]
    genre = params[:genre]

    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    return erb(:added_artist)
  end

  def invalid_request?
    # Are the params nil?
    return true if  params[:name] == nil || 
                    params[:genre] == nil
  
    # Are they empty strings?
    return true if  params[:name] == "" || 
                    params[:genre] == ""

    return false
  end
end