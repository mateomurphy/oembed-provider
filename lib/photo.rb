require 'uri'

class Photo
  THUMBNAIL_WIDTH = 200

  def self.fetch(params = {})
    url_params = parse_url_param(params[:url])

    response = find_photo(url_params['photo'], params)

    new(response, params) if response
  end

  def self.parse_url_param(url)
    Rack::Utils.parse_nested_query(URI(url).query)
  end

  def self.find_photo(id, params = {})
    Unsplash::Photo.find(id, width: params[:maxwidth], height: params[:maxheight])
  rescue Unsplash::Error => e
    if e.message == "Couldn't find Photo"
      nil
    else
      raise e
    end
  end

  def initialize(object, params = {})
    @object = object
    @width = params[:maxwidth] && params[:maxwidth].to_i
    @height = params[:maxheight] && params[:maxheight].to_i
  end

  def thumbnail_height
    THUMBNAIL_WIDTH * @object.height / @object.width
  end

  def image_url
    if @object.urls['custom']
      @object.urls['custom']
    else
      @object.urls['full']
    end
  end

  def custom?
    @width || @height
  end

  def width
    if custom?
      @width || (@height * @object.width / @object.height)
    else
      @object.width
    end
  end

  def height
    if custom?
      @height || (@width * @object.height / @object.width)
    else
      @object.height
    end
  end

  def attributes
    {
      version: "1.0",
      type: "photo",
      provider_name: "Unsplash",
      provider_url: "unsplash.com",
      author_name: @object.user['name'],
      author_url: @object.user['links']['html'],
      url: image_url,
      width: width,
      height: height,
      thumbnail_url: @object.urls['thumb'],
      thumbnail_width: THUMBNAIL_WIDTH,
      thumbnail_height: thumbnail_height
    }
  end
end
