require 'httparty'
require 'json'
require './book'

def get_volumes(query='programming ruby', max_results=10)
  url = "https://www.googleapis.com/books/v1/volumes?q=#{URI::encode(query)}&maxResults=#{max_results}"
  HTTParty.get(url)
end

volumes = get_volumes('programming ruby', 10)

unless volumes.nil? || volumes.empty?
  puts "\n========== Raw Content ==========\n\n"
  puts volumes
end

items = volumes['items'] || []

info_array = []
items.each { |i| info_array << i['volumeInfo'] unless i['volumeInfo'].nil? || i['volumeInfo'].empty? }

books = info_array.map do |v|
  options = {
    title: v['title'],
    authors: v['authors'],
    publisher: v['publisher'],
    description: v['description'],
    page_count: v['pageCount']
  }
  Book.new options
end

puts "\n========== Formatted Content ==========\n\n"

books.each { |v| puts v.to_hash }