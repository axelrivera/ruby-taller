class Book
  attr_accessor :title, :authors, :publisher, :description, :page_count
  
  def initialize(options={})
    @title = options[:title]
    @authors = options[:authors] || []
    @publisher = options[:publisher]
    @description = options[:description]
    @page_count = options[:page_count] || 0
  end
  
  def authors_string
    @authors.join(', ')
  end
  
  def to_json(*a)
    to_hash.to_json(*a)
  end
  
  def to_hash
    {
      title: @title,
      authors: @authors,
      publisher: @publisher,
      description: @description,
      page_count: @page_count
    }
  end
end

