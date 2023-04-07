require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET to /" do
    it 'contains a h1 title' do
      response = get('/')
  
      expect(response.body).to include('<h1>Welcome to my page</h1>')
    end
    
    it 'contains a h1' do
      response = get('/')
  
      expect(response.body).to include('<h1>')
    end
  end

  context "GET to /hello" do
    it 'returns hello message with @name' do
      response = get('/hello', name: 'Chris')
  
      expect(response.body).to include('<h1>Hello Chris!</h1>')
    end
    
    it 'contains a div' do
      response = get('/hello')
  
      expect(response.body).to include('<h1>')
    end
  end

  context "GET to /albums/:id" do
    it 'returns returns an album matching id' do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1> Surfer Rosa </h1>')
      expect(response.body).to include('release_year: 1988')
      expect(response.body).to include('')
    end
    
    it 'contains a div' do
      response = get('/hello')
  
      expect(response.body).to include('<h1>')
    end
  end

  context "GET to /artists/:id" do
    it 'returns matching artists to id' do
      response = get('/artists/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1> ABBA </h1>')
      expect(response.body).to include('genre: Pop')
    end
    
    it 'contains a div' do
      response = get('/hello')
  
      expect(response.body).to include('<h1>')
    end
  end

  it 'test all_albums get method' do
    response = get('/albums')

    expect(response.status).to eq(200)
    expect(response.body).to include('a href="/albums/10')
    expect(response.body).to include('title:  Surfer Rosa')
    expect(response.body).to include('release_year: 1988')
  end
  
  it 'tests all artists get request' do
    response = get('/artists')
  
    expect(response.status).to eq(200)
    expect(response.body).to include('a href="/artists/1')
    expect(response.body).to include('name:  ABBA')
    expect(response.body).to include('genre:  Pop')
  end

  context "GET /albums/new" do
    it 'returns the form page' do
      response = get('/albums/new')
  
      expect(response.status).to eq(200)
  
      # Assert we have the correct form tag with the action and method.
      expect(response.body).to include('form action="/albums" method="POST"')
  
      # We can assert more things, like having
      # the right HTML form inputs, etc.
    end
  end

  context "POST /albums" do
    it 'returns a success page' do
      # We're now sending a POST request,
      # simulating the behaviour that the HTML form would have.
      response = post(
        '/albums',
        title: 'Given to fly',
        release_year: '1999',
        artist_id: '6'
      )
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Album added to database</h1>')
    end
  
    it 'responds with 400 status if parameters are invalid' do
      response = post(
        '/albums',
        title: '',
        release_year: '',
        artist_id: ''
      )
      expect(response.status).to eq(400)
    end
  end

  context "GET /artists/new" do
    it 'returns the form page' do
      response = get('/artists/new')
  
      expect(response.status).to eq(200)
  
      # Assert we have the correct form tag with the action and method.
      expect(response.body).to include('form action="/artists" method="POST"')
  
      # We can assert more things, like having
      # the right HTML form inputs, etc.
    end
  end

  context "POST /artists" do
    it 'returns a success page' do
      # We're now sending a POST request,
      # simulating the behaviour that the HTML form would have.
      response = post(
        '/artists',
        name: 'Pearl Jam',
        genre: 'Grunge'
      )
  
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Artist added to database</h1>')
    end
  
    it 'responds with 400 status if parameters are invalid' do
      response = post(
        '/albums',
        name: '',
        genre: ''
      )
      expect(response.status).to eq(400)
    end
  end
end
