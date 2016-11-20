require './config/unsplash'
require './lib/photo'
require './lib/xml_formatter'

class App < Grape::API
  content_type :json, 'application/json'
  content_type :xml, 'application/xml'

  default_format :json

  formatter :xml, XmlFormatter

  params do
    requires :url, type: String, desc: 'URL'
    optional :maxwidth, type: Integer, desc: 'Maximum width'
    optional :maxheight, type: Integer, desc: 'Maximum height'
  end

  get :oembed do
    photo = Photo.fetch(params)

    error!("Not found", 404) if !photo

    photo.attributes
  end
end
