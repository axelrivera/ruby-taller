require 'sinatra'
require 'httparty'
require 'json'
require './book'

helpers do
  def get_volumes(query='programming ruby', max_results=10)
    url = "https://www.googleapis.com/books/v1/volumes?q=#{URI::encode(query)}&maxResults=#{max_results}"
    HTTParty.get(url)
  end
end

before do
  content_type 'application/json'
end

get '/' do
   { message: 'hello, world!' }.to_json
end

get '/books' do
  halt 500 if params[:query].nil? || params[:query].empty?
  
  query = params[:query]
  max_results = params[:max_results] || 20
  
  volumes = get_volumes(query, max_results)
  
  puts volumes
    
  halt 500 if volumes['items'].nil? || volumes['items'].empty?

  volume_info = []
  volumes['items'].each { |i| volume_info << i['volumeInfo'] unless i['volumeInfo'].nil? || i['volumeInfo'].empty? }

  books = volume_info.map do |v|
    options = {
      title: v['title'],
      authors: v['authors'],
      publisher: v['publisher'],
      description: v['description'],
      page_count: v['pageCount']
    }
    Book.new options
  end
  
  books.to_json
end